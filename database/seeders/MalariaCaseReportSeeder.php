<?php

namespace Database\Seeders;

use App\Models\MalariaCaseReport;
use App\Services\Constants\SelectOptions;
use Carbon\Carbon;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;

class MalariaCaseReportSeeder extends Seeder
{
    // generate 5 volunteers
    private function generateVolunteers(): array
    {
        // get townships
        $townships = array_keys(SelectOptions::townshipOptions());

        // initiate empty volunteers
        $volunteers = [];

        // loop random 5 townships
        for ($i = 1; $i <= 5; $i++) {

            $township = $townships[array_rand($townships)];

            // get children villages
            $villages = SelectOptions::getVillagesByTownship($township);

            // if villages is not empty get one random village otherwise blank
            $village = !empty($villages) ? array_rand($villages) : '';

            // assign each volunteer
            $volunteers[] = [
                'volunteer_name' => $this->generateName(),
                'volunteer_township' => $township,
                'volunteer_village' => $village,
            ];
        }
        return $volunteers;
    }
    // generate reporters
    private function generateReporters(): array
    {
        // get townships
        $townships = array_keys(SelectOptions::townshipOptions());
        // initiate empty reporters array
        $reporters = [];

        // generate two reporters
        for ($i = 1; $i <= 2; $i++) {
            // get township
            $township = $townships[array_rand($townships)];
            // get villages
            $villages = SelectOptions::getVillagesByTownship($township);
            // if villages is not empty, get a random village. Otherwise blank
            $village = !empty($villages) ? array_rand($villages) : '';
            // assign to each reporter
            $reporters[] = [
                'reporter_name' => $this->generateName(),
                'reporter_id' => \Illuminate\Support\Str::uuid()->toString(),
                'reporter_township' => $township,
                'reporter_village' => $village,

            ];
        }

        return $reporters;
    }

    // generate age data
    private function generateAgeData(): array
    {
        $ageUnits = ['day', 'month', 'year'];
        $ageUnit = $ageUnits[array_rand($ageUnits)];

        $age = match ($ageUnit) {
            'day' => rand(1, 30),
            'month' => rand(1, 12),
            'year' => rand(1, 90),
        };

        return [
            'age_unit' => $ageUnit,
            'age' => $age,
        ];
    }
    // generate month and year for last 5 months
    private function generateMontyYearData(): array
    {
        // get a date between today and 5 motnhs ago
        $startDate = now()->subMonths(5);
        $endDate = now();

        // generate random timestamp between start and end date
        $randomTimestamp = mt_rand($startDate->timestamp, $endDate->timestamp);

        // convert to Carbon object
        $randomDate = Carbon::createFromTimestamp($randomTimestamp);

        return [
            'month' => $randomDate->format('F'),
            'year' => $randomDate->format('Y'),
            'test_date' => $randomDate->format('Y-m-d'),
        ];
    }
    // generate names
    private function generateName(): string
    {
        $firstNames = [
            'Aung',
            'Aye',
            'Khin',
            'Kyaw',
            'Maung',
            'Min',
            'Mya',
            'Myint',
            'Nay',
            'Nilar',
            'Soe',
            'Thein',
            'Thin',
            'Thu',
            'Tun',
            'Win',
            'Zaw',
            'Htay',
            'Su',
            'Phyo'
        ];

        $middleNames = [
            'Aung',
            'Aye',
            'Htay',
            'Khin',
            'Kyaw',
            'Lin',
            'Lwin',
            'Maung',
            'Min',
            'Moe',
            'Mya',
            'Myat',
            'Myint',
            'Nwe',
            'San',
            'Soe',
            'Thein',
            'Thu',
            'Win',
            'Zaw'
        ];

        $lastNames = [
            'Aung',
            'Htay',
            'Khaing',
            'Khin',
            'Kyaw',
            'Latt',
            'Lin',
            'Lwin',
            'Min',
            'Moe',
            'Myint',
            'Naing',
            'Oo',
            'San',
            'Soe',
            'Thein',
            'Thu',
            'Tun',
            'Win',
            'Zaw'
        ];

        // randomize if name has 2 or 3 parts
        $nameParts = rand(0, 1) ? 2 : 3;

        if ($nameParts == 2) {
            return $firstNames[array_rand($firstNames)] . ' ' . $lastNames[array_rand($lastNames)];
        } else {
            return $firstNames[array_rand($firstNames)] . ' ' . $middleNames[array_rand($middleNames)] . ' ' . $lastNames[array_rand($lastNames)];
        }
    }

    /**
     * Run the database seeds.
     */
    public function run(): void
    {
        // generate 100 records
        for ($i = 0; $i < 100; $i++) {
            $sex = rand(0, 1) ? 'm' : 'f';
            $rdtResult = rand(0, 1) ? true : false;

            $symptom = null;
            $act24 = $act18 = $act12 = $act6 = $cq = $pq = false;

            $act24_amount = $act18_amount = $act12_amount = $act6_amount = $cq_amount = $pq_amount = null;

            $receivedTreatment = null;

            $isReferred = $isDeath = false;

            $personsWithDisability = $internallyDisplaced = false;

            $volunteers = $this->generateVolunteers();
            $randomVolunteer = $volunteers[array_rand($volunteers)];

            $reporters = $this->generateReporters();
            $randomReporter = $reporters[array_rand($reporters)];

            if ($rdtResult == true) {
                $symptom = rand(0, 1) ? 'moderate' : 'severe';

                // randomly select only one medication
                $medications = ['act24', 'act18', 'act12', 'act6', 'cq', 'pq'];
                $selectedMedication = $medications[array_rand($medications)];

                // set only selected medication to be true
                // double $$ is a variable variable
                $$selectedMedication = true;

                // add _amount suffix to selected medication
                $amountVariable = $selectedMedication . '_amount';

                // generate random amount based on selected medication
                switch ($selectedMedication) {
                    case 'act24':
                        $$amountVariable = rand(1, 24);
                        break;
                    case 'act18':
                        $$amountVariable = rand(1, 18);
                        break;
                    case 'act12':
                        $$amountVariable = rand(1, 12);
                        break;
                    case 'act6':
                        $$amountVariable = rand(1, 6);
                        break;
                    case 'cq':
                    case 'pq':
                        $$amountVariable = rand(1, 10);
                        break;
                }

                $isReferred = rand(0, 1) ? true : false;

                $receivedTreatment = rand(0, 1) ? '<24' : '>24';

                $personsWithDisability = rand(1, 100) <= 10 ? true : false;

                $internallyDisplaced = rand(1, 50) <= 10 ? true : false;
            }

            MalariaCaseReport::create([
                'test_date' => $this->generateMontyYearData()['test_date'],
                'treatment_month' => $this->generateMontyYearData()['month'],
                'treatment_year' => $this->generateMontyYearData()['year'],
                'patient_name' => $this->generateName(),
                'age_unit' => $this->generateAgeData()['age_unit'],
                'age' => $this->generateAgeData()['age'],
                'sex' => $sex,
                'preg' => $sex === 'f' ? (rand(0, 1) ? true : false) : false,
                'lact_mother' => $sex === 'f' ? (rand(0, 1) ? true : false) : false,
                'address' => 'Random Address',
                'rdt_result' => $rdtResult,
                'malaria_parasite' => $rdtResult == true ? collect(['pf', 'pv', 'mixed'])->random() : null,
                'received_treatment' => $receivedTreatment,
                'act24' => $act24,
                'act24_amount' => $act24_amount,
                'act18' => $act18,
                'act18_amount' => $act18_amount,
                'act12' => $act12,
                'act12_amount' => $act12_amount,
                'act6' => $act6,
                'act6_amount' => $act6_amount,
                'cq' => $cq,
                'cq_amount' => $cq_amount,
                'pq' => $pq,
                'pq_amount' => $pq_amount,
                'is_referred' => $isReferred,
                'is_dead' => $isDeath,
                'symptoms' => $symptom,
                'travelling_before' => false,
                'persons_with_disability' => $personsWithDisability,
                'internally_displaced' => $internallyDisplaced,
                'occupation' => null,
                'volunteer_name' => $randomVolunteer['volunteer_name'],
                'volunteer_township' => $randomVolunteer['volunteer_township'],
                'volunteer_village' => $randomVolunteer['volunteer_village'],
                'remark' => null,
                'reporter_name' => $randomReporter['reporter_name'],
                'reporter_id' => $randomReporter['reporter_id'],
                'reporter_village' => $randomReporter['reporter_village'],
                'reporter_township' => $randomReporter['reporter_township']
            ]);
        }
    }
}
