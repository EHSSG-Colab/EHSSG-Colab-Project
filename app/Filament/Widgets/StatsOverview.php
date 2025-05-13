<?php

namespace App\Filament\Widgets;

use App\Models\MalariaCaseReport;
use Filament\Widgets\StatsOverviewWidget as BaseWidget;
use Filament\Widgets\StatsOverviewWidget\Stat;

class StatsOverview extends BaseWidget
{
    protected function getStats(): array
    {
        // TOTAL CASES
        $totalCases = MalariaCaseReport::query()
            ->count();

        // TOTAL POSITIVE CASES
        $totalPositiveCases = MalariaCaseReport::query()
            ->where('rdt_result', true)->count();

        // POSITIVE RATE
        $positiveRate = $totalCases > 0 ?
            number_format(($totalPositiveCases / $totalCases) * 100, 2) . "%"
            : "0.00%";

        return [
            // TOTAL CASES
            Stat::make(
                label: 'Total cases',
                value: $totalCases
            ),
            // TOTAL POSITIVE CASES
            Stat::make(
                label: 'Totao positive cases',
                value: $totalPositiveCases,
            ),
            // POSITIVE RATE
            Stat::make(
                label: 'Positive rate',
                value: $positiveRate,
            )
        ];
    }
}
