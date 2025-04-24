<?php

namespace App\Filament\Resources\MalariaCaseReportResource\Pages;

use App\Filament\Resources\MalariaCaseReportResource;
use Filament\Actions;
use Filament\Resources\Pages\CreateRecord;

class CreateMalariaCaseReport extends CreateRecord
{
    protected static string $resource = MalariaCaseReportResource::class;

    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }

    protected function getCreatedNotificationTitle(): ?string
    {
        return 'Malaria Case Report Is Successfully Created';
    }

    protected function mutateFormDataBeforeCreate(array $data): array
    {
        // dd($data);
        return $data;
    }
}
