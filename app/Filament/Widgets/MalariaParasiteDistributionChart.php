<?php

namespace App\Filament\Widgets;

use App\Models\MalariaCaseReport;
use Filament\Widgets\ChartWidget;

class MalariaParasiteDistributionChart extends ChartWidget
{
    protected static ?string $heading = 'Malaria Parasite Distribution';

    protected static ?int $sort = 7;

    protected function getData(): array
    {
        // get malaria parasite distribution
        $malariaParasites = MalariaCaseReport::selectRaw("
            COUNT(*) AS count,
            malaria_parasite
            ")
            ->where('rdt_result', 1)
            ->whereNotNull('malaria_parasite')
            ->groupBy('malaria_parasite')
            ->get();

        // labels
        $labels = [];

        // data
        $data = [];

        foreach ($malariaParasites as $malariaParasite) {
            $labels[] = ucfirst($malariaParasite->malaria_parasite);
            $data[] = $malariaParasite->count;
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
