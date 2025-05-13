<?php

namespace App\Filament\Widgets;

use App\Models\MalariaCaseReport;
use Filament\Widgets\ChartWidget;

class VolunteerDistributionChart extends ChartWidget
{
    protected static ?string $heading = 'Volunteer Distribution';

    protected function getData(): array
    {
        // get volunteer distribution
        $volunteers = MalariaCaseReport::selectRaw("
            COUNT(*) AS count,
            volunteer_name
            ")
            ->groupBy('volunteer_name')
            ->orderBy('count', 'desc')
            ->limit(5)
            ->get();

        // labels
        $labels = [];

        // data
        $data = [];

        foreach ($volunteers as $volunteer) {
            $labels[] = $volunteer->volunteer_name;
            $data[] = $volunteer->count;
        }

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
