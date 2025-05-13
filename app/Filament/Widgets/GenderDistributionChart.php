<?php

namespace App\Filament\Widgets;

use App\Models\MalariaCaseReport;
use Filament\Widgets\ChartWidget;

class GenderDistributionChart extends ChartWidget
{
    protected static ?string $heading = 'Gender Distribution';

    protected static ?int $sort = 5;

    protected function getData(): array
    {
        // get genders
        $genders = MalariaCaseReport::selectRaw(
            'sex, count(*) AS count'
        )
            ->groupBy('sex')
            ->get();

        $labels = [];
        $data = [];

        foreach ($genders as $gender) {
            $labels[] = ucfirst($gender->sex);
            $data[] = $gender->count;
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
