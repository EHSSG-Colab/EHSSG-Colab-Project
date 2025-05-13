<?php

namespace App\Filament\Widgets;

use App\Models\MalariaCaseReport;
use Filament\Widgets\ChartWidget;

class TreatmentDistributionChart extends ChartWidget
{
    protected static ?string $heading = 'Treatment Distribution';

    protected static ?int $sort = 2;

    protected function getData(): array
    {
        // get treatments
        $treatments = MalariaCaseReport::selectRaw("
            SUM(CASE WHEN act24=1 THEN 1 ELSE 0 END)AS act24_dist,
            SUM(CASE WHEN act18=1 THEN 1 ELSE 0 END)AS act18_dist,
            SUM(CASE WHEN act12=1 THEN 1 ELSE 0 END)AS act12_dist,
            SUM(CASE WHEN act6=1 THEN 1 ELSE 0 END)AS act6_dist,
            SUM(CASE WHEN cq=1 THEN 1 ELSE 0 END)AS cq_dist,
            SUM(CASE WHEN pq=1 THEN 1 ELSE 0 END)AS pq_dist
            ")
            ->first();

        // labels
        $labels = [
            'ACT 24',
            'ACT 18',
            'ACT 12',
            'ACT 6',
            'Chloroquine',
            'Primaquine'
        ];

        // data
        $data = [
            $treatments->act24_dist,
            $treatments->act18_dist,
            $treatments->act12_dist,
            $treatments->act6_dist,
            $treatments->cq_dist,
            $treatments->pq_dist
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
        return 'bar';
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
                'easing' => 'easeOutCubic',
                'duration' => 1000,
            ],
            'scales' => [
                'y' => [
                    'grid' => [
                        'display' => false,
                    ]
                ]
            ]
        ];
    }
}
