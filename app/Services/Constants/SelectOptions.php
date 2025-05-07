<?php

namespace App\Services\Constants;

class SelectOptions
{
    public static function townshipOptions(): array
    {
        return [
            'Township One' => 'Township One',
            'Township Two' => 'Township Two',
            'Township Three' => 'Township Three'
        ];
    }

    public static function getVillagesByTownship(?string $township): array
    {
        $townshipVillage = [
            [
                'township' => 'Tonwship One',
                'villages' => [
                    'Village One',
                    'Village Two',
                    'Village Three'
                ],
            ],
            [
                'township' => 'Tonwship Two',
                'villages' => [
                    'Village Four',
                    'Village Five',
                    'Village Six'
                ],
            ],
            [
                'township' => 'Tonwship Three',
                'villages' => [
                    'Village Seven',
                    'Village Eight',
                    'Village Nine'
                ],
            ],
        ];

        foreach ($townshipVillage as $data) {
            if ($township !== null && $data['township'] === $township) {
                // $data['villages'] will only return a simple array
                // An associative array with array_combine will both return and display the village name
                return array_combine($data['villages'], $data['villages']);
            }
        }
        return [];
    }
}
