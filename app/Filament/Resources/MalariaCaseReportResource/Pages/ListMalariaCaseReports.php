<?php

namespace App\Filament\Resources\MalariaCaseReportResource\Pages;

use App\Filament\Resources\MalariaCaseReportResource;
use Filament\Actions;
use Filament\Resources\Pages\ListRecords;

class ListMalariaCaseReports extends ListRecords
{
    protected static string $resource = MalariaCaseReportResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\CreateAction::make(),
        ];
    }
}
