-- Drop the function if it exists to avoid conflicts
DROP FUNCTION IF EXISTS update_uq_metrics();

-- Create a new function with RETURNS TRIGGER to work with the trigger
CREATE OR REPLACE FUNCTION update_uq_metrics()
RETURNS TRIGGER AS $$
DECLARE
    mean_value DECIMAL;
    std_dev DECIMAL;
    reliability_index DECIMAL;
BEGIN
    -- Calculate mean and standard deviation for test_value in Material_Quality
    SELECT AVG(test_value), STDDEV(test_value)
    INTO mean_value, std_dev
    FROM Material_Quality
    WHERE Source_ID = NEW.Source_ID;

    -- Calculate reliability index
    IF std_dev > 0 THEN
        reliability_index := mean_value / std_dev;
    ELSE
        reliability_index := 0;
    END IF;

    -- Check if entry for Source_ID already exists in UQ_Results
    IF EXISTS (SELECT 1 FROM UQ_Results WHERE Source_ID = NEW.Source_ID) THEN
        -- Update the existing entry
        UPDATE UQ_Results
        SET Mean_Value = mean_value,
            Standard_Deviation = std_dev,
            Reliability_Index = reliability_index
        WHERE Source_ID = NEW.Source_ID;
    ELSE
        -- Insert a new entry
        INSERT INTO UQ_Results (Source_ID, Mean_Value, Standard_Deviation, Reliability_Index)
        VALUES (NEW.Source_ID, mean_value, std_dev, reliability_index);
    END IF;

    RETURN NEW;  -- Return NEW to satisfy the trigger requirement
END;
$$ LANGUAGE plpgsql;

-- Drop the trigger if it exists to avoid conflicts
DROP TRIGGER IF EXISTS recalculate_uq_after_insert ON Material_Quality;

-- Create a trigger to execute the update_uq_metrics function after insert or update on Material_Quality
CREATE TRIGGER recalculate_uq_after_insert
AFTER INSERT OR UPDATE ON Material_Quality
FOR EACH ROW
EXECUTE FUNCTION update_uq_metrics();
