-- Drop the trigger first to avoid dependency conflicts
DROP TRIGGER IF EXISTS recalculate_uq_after_insert ON Material_Quality;

-- Drop the function if it exists to avoid conflicts
DROP FUNCTION IF EXISTS update_uq_metrics();

-- Re-create the function without BEGIN/COMMIT and with debugging output
CREATE OR REPLACE FUNCTION update_uq_metrics()
RETURNS TRIGGER AS $$
DECLARE
    calc_mean DECIMAL(10, 4);
    calc_std_dev DECIMAL(10, 4);
    calc_reliability_index DECIMAL(10, 4);
BEGIN
    RAISE NOTICE 'Trigger fired for Source_ID = %', NEW.Source_ID;

    -- Calculate mean and standard deviation for test_value in Material_Quality
    SELECT AVG(test_value), STDDEV(test_value)
    INTO calc_mean, calc_std_dev
    FROM Material_Quality
    WHERE Source_ID = NEW.Source_ID;

    RAISE NOTICE 'Calculated Mean: %, Std Dev: %', calc_mean, calc_std_dev;

    -- Calculate reliability index
    IF calc_std_dev > 0 THEN
        calc_reliability_index := calc_mean / calc_std_dev;
    ELSE
        calc_reliability_index := 0;
    END IF;

    RAISE NOTICE 'Calculated Reliability Index: %', calc_reliability_index;

    -- Check if entry for Source_ID already exists in UQ_Results
    IF EXISTS (SELECT 1 FROM UQ_Results WHERE Source_ID = NEW.Source_ID) THEN
        RAISE NOTICE 'Preparing to update existing entry in UQ_Results for Source_ID = %', NEW.Source_ID;
        
        -- Update the existing entry
        UPDATE UQ_Results
        SET Mean_Value = calc_mean,
            Standard_Deviation = calc_std_dev,
            Reliability_Index = calc_reliability_index
        WHERE Source_ID = NEW.Source_ID;

        RAISE NOTICE 'Updated UQ_Results for Source_ID = % with Mean: %, Std Dev: %, Reliability Index: %',
            NEW.Source_ID, calc_mean, calc_std_dev, calc_reliability_index;
    ELSE
        -- Insert a new entry if not exists
        INSERT INTO UQ_Results (Source_ID, Mean_Value, Standard_Deviation, Reliability_Index)
        VALUES (NEW.Source_ID, calc_mean, calc_std_dev, calc_reliability_index);

        RAISE NOTICE 'Inserted new record into UQ_Results for Source_ID = %', NEW.Source_ID;
    END IF;

    RETURN NEW;  -- Return NEW to satisfy the trigger requirement
END;
$$ LANGUAGE plpgsql;

-- Re-create the trigger to execute the update_uq_metrics function after insert or update on Material_Quality
CREATE TRIGGER recalculate_uq_after_insert
AFTER INSERT OR UPDATE ON Material_Quality
FOR EACH ROW
EXECUTE FUNCTION update_uq_metrics();
