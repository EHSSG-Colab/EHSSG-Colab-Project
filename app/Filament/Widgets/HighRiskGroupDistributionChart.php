<?php

namespace App\Filament\Widgets;

use App\Models\MalariaCaseReport;
use Filament\Widgets\ChartWidget;

class HighRiskGroupDistributionChart extends ChartWidget
{
    protected static ?string $heading = 'High risk group distribution';

    protected function getData(): array
    {
        // get high risk groups
        $highRiskGroups = MalariaCaseReport::selectRaw("
            SUM(CASE WHEN preg=1 THEN 1 ELSE 0 END)AS pregnancy,
            SUM(CASE WHEN age_unit='month' AND age < 12 THEN 1 ELSE 0 END)AS infant,
            SUM(CASE WHEN lact_mother=1 THEN 1 ELSE 0 END) AS lactating,
            SUM(CASE WHEN persons_with_disability=1 THEN 1 ELSE 0 END)AS disabled,
            SUM(CASE WHEN internally_displaced=1 THEN 1 ELSE 0 END)AS idp
            ")
            ->where('rdt_result', 1)
            ->first();

        // labels
        $labels = [
            'Pregnancy',
            'Infants',
            'Lactating mothers',
            'Disabled',
            'IDP'
        ];

        // data
        $data = [
            $highRiskGroups->pregnancy,
            $highRiskGroups->infant,
            $highRiskGroups->lactating,
            $highRiskGroups->disabled,
            $highRiskGroups->idp
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
            'labels' => $labels
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
