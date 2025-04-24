<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\MalariaCaseReport;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Api\ApiController;

class MalariaCaseReportController extends ApiController
{
    public function index(Request $request)
    {
        $malariaCases = MalariaCaseReport::all();
        return $malariaCases;
    }

    /**
     * Handle mobile app data synchronization
     * Receives batch records from mobile app and processes them individually
     * 
     * @param Request $request The incoming HTTP request containing JSON data
     * @return \Illuminate\Http\JsonResponse Response with processing results
     */
    public function mobileSync(Request $request)
    {
        // Decode the incoming JSON data from the request body
        $data = $request->json()->all();

        // Validate the basic structure of the data
        if (!isset($data['data']) || !is_array($data['data'])) {
            return $this->sendError('Validation Error', 'Invalid data format. Expected "data" array.', 400);
        }

        // Extract the records array from the request
        $records = $data['data'];

        // Array to store individual response for each record
        $responses = [];

        // Process each record individually
        foreach ($records as $record) {
            try {
                // Check if a record with the same ID, patient name, and reporter already exists
                // This identifies whether we need to update or insert
                $existingRecord = MalariaCaseReport::where('id', $record['id'])
                    ->where('patient_name', $record['patient_name'])
                    ->where('reporter_id', $record['data_collector_id'])
                    ->first();

                // Map mobile app fields to database fields
                $malariaCaseData = [
                    // Date and time information
                    'test_date' => $record['date_of_rdt'], // Date when RDT was performed
                    'treatment_month' => $record['t_month'], // Treatment month
                    'treatment_year' => $record['t_year'], // Treatment year

                    // Patient information
                    'patient_name' => $record['patient_name'], // Patient's name
                    'age_unit' => $record['age_unit'], // Unit of age (years, months, etc.)
                    'age' => $record['patient_age'], // Patient's age value
                    'sex' => $record['patient_sex'], // Patient's sex
                    'preg' => $record['is_pregnant'] === 'Yes', // Whether patient is pregnant
                    'lact_mother' => $record['is_lactating_mother'] === 'Yes', // Whether patient is a lactating mother
                    'address' => $record['patient_address'], // Patient's address

                    // Test results
                    'rdt_result' => $record['rdt_result'] === 'Positive', // RDT test result
                    'malaria_parasite' => $record['malaria_parasite'], // Type of malaria parasite

                    // Treatment information
                    'received_treatment' => $record['received_treatment'] === 'Yes', // Whether patient received treatment

                    // ACT 24 medication
                    'act24' => $record['act_24'] === 'Yes', // Whether ACT 24 was prescribed
                    'act24_amount' => (int) $record['act_24_count'], // Amount of ACT 24 prescribed

                    // ACT 18 medication
                    'act18' => $record['act_18'] === 'Yes', // Whether ACT 18 was prescribed
                    'act18_amount' => (int) $record['act_18_count'], // Amount of ACT 18 prescribed

                    // ACT 12 medication
                    'act12' => $record['act_12'] === 'Yes', // Whether ACT 12 was prescribed
                    'act12_amount' => (int) $record['act_12_count'], // Amount of ACT 12 prescribed

                    // ACT 6 medication
                    'act6' => $record['act_6'] === 'Yes', // Whether ACT 6 was prescribed
                    'act6_amount' => (int) $record['act_6_count'], // Amount of ACT 6 prescribed

                    // Chloroquine medication
                    'cq' => $record['chloroquine'] === 'Yes', // Whether Chloroquine was prescribed
                    'cq_amount' => (int) $record['chloroquine_count'], // Amount of Chloroquine prescribed

                    // Primaquine medication
                    'pq' => $record['primaquine'] === 'Yes', // Whether Primaquine was prescribed
                    'pq_amount' => (int) $record['primaquine_count'], // Amount of Primaquine prescribed

                    // Patient status
                    'is_referred' => $record['is_referred'] === 'Yes', // Whether patient was referred
                    'is_dead' => $record['is_dead'] === 'Yes', // Whether patient died
                    'symptoms' => $record['symptoms'], // Patient's symptoms

                    // Additional information
                    'travelling_before' => $record['has_travelled'] === 'Yes', // Whether patient traveled before
                    'persons_with_disability' => $record['is_person_with_disabilities'] === 'Yes', // Whether patient has disabilities
                    'internally_displaced' => $record['is_internally_displaced'] === 'Yes', // Whether patient is internally displaced
                    'occupation' => $record['occupation'], // Patient's occupation

                    // Volunteer information
                    'volunteer_name' => $record['volunteer_name'], // Volunteer's name
                    'volunteer_village' => $record['volunteer_village'], // Volunteer's village
                    'volunteer_township' => $record['volunteer_township'], // Volunteer's township

                    // Additional notes
                    'remark' => $record['remark'], // Additional remarks

                    // Reporter (data collector) information
                    'reporter_name' => $record['data_collector_name'], // Reporter's name
                    'reporter_id' => $record['data_collector_id'], // Reporter's ID
                    'reporter_village' => $record['data_collector_village'], // Reporter's village
                    'reporter_township' => $record['data_collector_township'], // Reporter's township
                ];

                if ($existingRecord) {
                    // Update existing record with new data
                    $existingRecord->update($malariaCaseData);
                    $responses[] = [
                        'message' => 'UPDATE Success',
                        'id' => $record['id']
                    ];
                } else {
                    // Create new record with the data
                    $newRecord = MalariaCaseReport::create($malariaCaseData);
                    $responses[] = [
                        'message' => 'INSERT Success',
                        'id' => $record['id']
                    ];
                }
            } catch (\Exception $e) {
                // Log and include any processing errors for this record
                \Log::error('Error syncing malaria record: ' . $e->getMessage(), [
                    'record' => $record,
                    'trace' => $e->getTraceAsString()
                ]);

                $responses[] = [
                    'message' => 'Error processing record',
                    'id' => $record['id'] ?? 'unknown',
                    'error' => $e->getMessage()
                ];
            }
        }

        // Return all processing results as JSON
        // This format matches what the Flutter app expects
        return response()->json($responses);
    }
}
