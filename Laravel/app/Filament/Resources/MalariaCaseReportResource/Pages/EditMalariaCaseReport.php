<?php

namespace App\Filament\Resources\MalariaCaseReportResource\Pages;

use App\Filament\Resources\MalariaCaseReportResource;
use Filament\Actions;
use Filament\Resources\Pages\EditRecord;

class EditMalariaCaseReport extends EditRecord
{
    protected static string $resource = MalariaCaseReportResource::class;

    protected function getHeaderActions(): array
    {
        return [
            Actions\DeleteAction::make(),
        ];
    }
    protected function getSavedNotificationTitle(): ?string
    {
        return 'User Updated Data Successfully';
    }
    protected function getRedirectUrl(): string
    {
        return $this->getResource()::getUrl('index');
    }
}
