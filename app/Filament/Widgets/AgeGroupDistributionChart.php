<?php

namespace App\Filament\Widgets;

use App\Models\MalariaCaseReport;
use Filament\Support\RawJs;
use Filament\Widgets\ChartWidget;

class AgeGroupDistributionChart extends ChartWidget
{
    protected static ?string $heading = 'Age Group Distribution';

    protected function getData(): array
    {
        // get age groups
        $ageGroups = MalariaCaseReport::selectRaw("
            SUM(CASE WHEN (age_unit='year' AND age < 5) OR age_unit='month' OR age_unit='day' THEN 1 ELSE 0 END) AS under_five,
            SUM(CASE WHEN age_unit='year' AND age >= 5 AND age <= 18 THEN 1 ELSE 0 END) AS five_to_eighteen,
            SUM(CASE WHEN age_unit='year' AND age > 18 THEN 1 ELSE 0 END) AS above_eighteen
            ")
            ->first();

        // labels
        $labels = [
            'Under 5',
            '5 to 18',
            'Above 18'
        ];

        // data
        $data = [
            $ageGroups->under_five,
            $ageGroups->five_to_eighteen,
            $ageGroups->above_eighteen,
        ];

        return [
            'datasets' => [
                [
                    'data' => $data,
                    'borderWidth' => 1,
                    'backgroundColor' => '#000',
                    'borderColor' => '#fff'
                ],
            ],
            'labels' => $labels,
        ];
    }

    protected function getType(): string
    {
        return 'pie';
    }

    // configuration
    protected function getOptions(): array
    {
        return [
            'plugins' => [
                'legend' => [
                    'position' => 'bottom',
                ],
            ],
            'responsive' => true,
            'maintainAspectRatio' => false,
            'animation' => [
                'easing' => 'linear',
                'duration' => 1000,
            ],
            'scales' => [
                'x' => [
                    'display' => false,
                ],
                'y' => [
                    'display' => false,
                ]
            ]
        ];
    }
}
