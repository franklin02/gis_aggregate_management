-- Enable necessary extensions for advanced functions if not already enabled
CREATE EXTENSION IF NOT EXISTS plpgsql;

-- Function: Calculate Mean Test Value for a Given Source
CREATE OR REPLACE FUNCTION calculate_mean_test_value(source_id_input VARCHAR(10))
RETURNS NUMERIC AS $$
DECLARE
    mean_value NUMERIC;
BEGIN
    SELECT AVG(Test_Value) INTO mean_value
    FROM Material_Quality
    WHERE Source_ID = source_id_input;

    RETURN COALESCE(mean_value, 0);  -- Returns 0 if no values found
END;
$$ LANGUAGE plpgsql;

-- Function: Calculate Standard Deviation for a Given Source
CREATE OR REPLACE FUNCTION calculate_stddev_test_value(source_id_input VARCHAR(10))
RETURNS NUMERIC AS $$
DECLARE
    stddev_value NUMERIC;
BEGIN
    SELECT STDDEV(Test_Value) INTO stddev_value
    FROM Material_Quality
    WHERE Source_ID = source_id_input;

    RETURN COALESCE(stddev_value, 0);  -- Returns 0 if no values found
END;
$$ LANGUAGE plpgsql;

-- Function: Calculate Reliability Index for a Given Source
-- Reliability Index = Mean Test Value / Standard Deviation
CREATE OR REPLACE FUNCTION calculate_reliability_index(source_id_input VARCHAR(10))
RETURNS NUMERIC AS $$
DECLARE
    mean_value NUMERIC;
    stddev_value NUMERIC;
    reliability_index NUMERIC;
BEGIN
    -- Get Mean and Standard Deviation
    SELECT calculate_mean_test_value(source_id_input) INTO mean_value;
    SELECT calculate_stddev_test_value(source_id_input) INTO stddev_value;

    -- Calculate Reliability Index (avoid division by zero)
    IF stddev_value = 0 THEN
        reliability_index := 0;  -- Define behavior when standard deviation is zero
    ELSE
        reliability_index := mean_value / stddev_value;
    END IF;

    RETURN reliability_index;
END;
$$ LANGUAGE plpgsql;

-- Function: Update Reliability Index in Material_Quality Table for Each Source
CREATE OR REPLACE FUNCTION update_reliability_index()
RETURNS VOID AS $$
DECLARE
    source RECORD;
BEGIN
    FOR source IN SELECT DISTINCT Source_ID FROM Material_Quality
    LOOP
        -- Update each record with calculated Reliability Index
        UPDATE Material_Quality
        SET Test_Value = calculate_reliability_index(source.Source_ID)
        WHERE Source_ID = source.Source_ID;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Trigger to Automatically Update Reliability Index When a New Test Value is Inserted
CREATE OR REPLACE FUNCTION update_reliability_on_insert()
RETURNS TRIGGER AS $$
BEGIN
    -- Recalculate and update the Reliability Index for the affected Source_ID
    PERFORM update_reliability_index();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create Trigger on Material_Quality Table to Recalculate Reliability Index on Insert
CREATE TRIGGER calculate_reliability_after_insert
AFTER INSERT ON Material_Quality
FOR EACH ROW
EXECUTE FUNCTION update_reliability_on_insert();

-- Create Trigger on Material_Quality Table to Recalculate Reliability Index on Update
CREATE TRIGGER calculate_reliability_after_update
AFTER UPDATE OF Test_Value ON Material_Quality
FOR EACH ROW
EXECUTE FUNCTION update_reliability_on_insert();

-- Optional: Function to Display All UQ Metrics for a Source (Mean, StdDev, Reliability)
CREATE OR REPLACE FUNCTION display_uq_metrics(source_id_input VARCHAR(10))
RETURNS TABLE(mean NUMERIC, stddev NUMERIC, reliability_index NUMERIC) AS $$
BEGIN
    RETURN QUERY
    SELECT calculate_mean_test_value(source_id_input),
           calculate_stddev_test_value(source_id_input),
           calculate_reliability_index(source_id_input);
END;
$$ LANGUAGE plpgsql;
