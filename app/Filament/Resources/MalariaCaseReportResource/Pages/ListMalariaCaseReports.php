<?php

namespace App\Filament\Resources\MalariaCaseReportResource\Pages;

use App\Filament\Resources\MalariaCaseReportResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;
use Filament\Support\Enums\MaxWidth;

class ListMalariaCaseReports extends ListRecords
{
    protected static string $resource = MalariaCaseReportResource::class;

    public function getMaxContentWidth(): MaxWidth
    {
        return MaxWidth::Full;
    }

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
