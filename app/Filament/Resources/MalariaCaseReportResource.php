<?php

namespace App\Filament\Resources;

use Filament\Forms;
use Filament\Tables;
use Filament\Forms\Get;
use Filament\Tables\Table;
use Doctrine\DBAL\Schema\Column;
use Filament\Resources\Resource;
use App\Models\MalariaCaseReport;
use Filament\Forms\Components\Radio;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Checkbox;
use Filament\Forms\Components\Textarea;
use Filament\Tables\Columns\TextColumn;
use Filament\Forms\Components\TextInput;
use Filament\Tables\Enums\FiltersLayout;
use Filament\Tables\Filters\SelectFilter;
use Filament\Tables\Filters\RadioFilter;
use Filament\Forms\Components\DatePicker;
use App\Filament\Resources\MalariaCaseReportResource\Pages;
use App\Filament\Resources\MalariaCaseReportResource\Pages\EditMalariaCaseReport;
use App\Filament\Resources\MalariaCaseReportResource\Pages\ListMalariaCaseReports;
use App\Filament\Resources\MalariaCaseReportResource\Pages\CreateMalariaCaseReport;
use App\Services\Appicon;
use Filament\Tables\Filters\Filter;
use Filament\Tables\Filters\TernaryFilter;
use Illuminate\Database\Eloquent\Builder;

class MalariaCaseReportResource extends Resource
{
    protected static ?string $model = MalariaCaseReport::class;
    protected static ?string $navigationIcon = Appicon::CASE_REPORT_ICON;
    protected static ?string $navigationGroup = 'Case Reports';


    public static function form(Forms\Form $form): Forms\Form
    {
        return $form->schema([
            // Reporter Details
            Section::make('Reporter Details')
                ->schema([
                    Forms\Components\TextInput::make('reporter_name')->required()->maxLength(255),
                    Forms\Components\TextInput::make('reporter_id')->required()->maxLength(255),
                    Forms\Components\TextInput::make('reporter_township')->required()->maxLength(255),
                    Forms\Components\TextInput::make('reporter_village')->required()->maxLength(255),

                ])

                ->columns(2),


            // Volentter
            Section::make('Volunteer Details')
                ->schema([
                    Forms\Components\TextInput::make('volunteer_name')
                        ->required()->maxLength(255),
                    Forms\Components\TextInput::make('volunteer_township')
                        ->required()->maxLength(255),
                    Forms\Components\TextInput::make('volunteer_village')
                        ->required()->maxLength(255),
                ])

                ->columns(2),

            // Reporting Details
            Section::make('Reporting Details')
                ->schema([

                    Forms\Components\DatePicker::make('test_date')
                        ->required()->native(false)->closeOnDateSelection(),
                    Forms\Components\Select::make('treatment_month')
                        ->options([
                            'january' => 'January',
                            'february' => 'February',
                            'march' => 'March',
                            'april' => 'April',
                            'may' => 'May',
                            'june' => 'June',
                            'july' => 'July',
                            'august' => 'August',
                            'september' => 'September',
                            'october' => 'October',
                            'november' => 'November',
                            'december' => 'December',
                        ])
                        ->placeholder('Select month')
                        ->native(false)
                        ->required(),

                    Forms\Components\Select::make('treatment_year')
                        ->options(function () {
                            $currentYear = date('Y');
                            $previousYear = $currentYear - 1;
                            return [
                                $previousYear => (string)$previousYear,
                                $currentYear => (string)$currentYear,
                            ];
                        })
                        ->required()
                        ->native(false),

                ])
                ->columns(3),

            // Patient Details
            Section::make('Patient Details')
                ->schema([
                    Forms\Components\TextInput::make('patient_name')
                        ->required()->maxLength(255),
                    Forms\Components\Select::make('age_unit')
                        ->required()->options(
                            [
                                'year' => 'Year',
                                'month' => 'Month',
                                'day' => 'Day',

                            ]
                        )
                        ->live()
                        ->placeholder('Select age unit')
                        ->native(false),


                    Forms\Components\TextInput::make('age')

                        ->required()
                        ->label('Patient Age')
                        ->numeric()

                        ->suffix(label: function (Get $get): string {
                            return $get('age_unit') ? ucfirst($get('age_unit')) . '(s)' : '';
                        }),


                    Forms\Components\Select::make('sex')

                        ->options([
                            'm' => 'Male',
                            'f' => 'Female',
                            'other' => 'Other',
                        ])
                        ->native(false)
                        ->nullable()
                        ->placeholder('Select gender')
                        ->live(),



                    Forms\Components\Toggle::make('preg')->hidden(fn(Get $get): bool => $get('sex') !== 'f'),
                    Forms\Components\Toggle::make('lact_mother')->hidden(fn(Get $get): bool => $get('sex') !== 'f'),
                    Forms\Components\TextInput::make('address')->maxLength(255)->required(),
                    Forms\Components\TextInput::make('occupation')->maxLength(255),
                ])
                ->columns(2),

            // RDT Diagnosis
            Section::make('RDT Diagnosis')
                ->schema([
                    Forms\Components\Toggle::make('rdt_result')

                        ->label('RDT Result')
                        ->helperText('Select "Negative" or "Positive"')
                        ->inline(false)
                        ->live(),

                    Forms\Components\Select::make('malaria_parasite')
                        ->options([
                            'pf' => 'Plasmodium falciparum',
                            'pv' => 'Plasmodium vivax',
                            'mixed' => 'Mixed Infection',


                        ])

                        ->placeholder('Select parasite type')
                        ->hidden(fn(Get $get): bool => $get('rdt_result') === false)
                        ->native(),


                    Forms\Components\Select::make('received_treatment')
                        ->label('Time of Treatment After Diagnosis')
                        ->options([
                            '<24' => 'Within 24 Hours',
                            '>24' => 'After 24 Hours',

                        ])

                        ->placeholder('Select timing of treatment')
                        ->hidden(fn(Get $get): bool => $get('rdt_result') === false)
                        ->native(),
                ])
                ->columns(3),




            // Treatment Details
            Section::make('Treatment Details')
                ->schema([



                    Forms\Components\Toggle::make('act24')
                        ->live(),

                    Forms\Components\TextInput::make('act24_amount')
                        ->numeric()
                        ->hidden(fn(Get $get): bool => $get('act24') === false),

                    Forms\Components\Toggle::make('act18')

                        ->live(),
                    Forms\Components\TextInput::make('act18_amount')
                        ->numeric()
                        ->hidden(fn(Get $get): bool => $get('act18') === false),

                    Forms\Components\Toggle::make('act12')

                        ->live(),
                    Forms\Components\TextInput::make('act12_amount')
                        ->numeric()
                        ->hidden(fn(Get $get): bool => $get('act12') === false),


                    Forms\Components\Toggle::make('act6')
                        ->live(),
                    Forms\Components\TextInput::make('act6_amount')->numeric()
                        ->hidden(fn(Get $get): bool => $get('act6') === false),

                    Forms\Components\Toggle::make('cq')
                        ->label('Chloroquine')

                        ->live(),
                    Forms\Components\TextInput::make('cq_amount')
                        ->label('Chloroquine amount')
                        ->numeric()
                        ->hidden(fn(Get $get): bool => $get('cq') === false),

                    Forms\Components\Toggle::make('pq')
                        ->label('Primaquine')

                        ->live(),
                    Forms\Components\TextInput::make('pq_amount')
                        ->label('Primaquine amount')
                        ->numeric()
                        ->hidden(fn(Get $get): bool => $get('pq') === false),
                ])
                ->hidden(fn(Get $get): bool => $get('rdt_result') === false)

                ->columns(1),


            // Other Details
            Section::make('Other Details')
                ->schema([
                    Forms\Components\Toggle::make('is_referred')
                        ->label('Has the patient referred to hospital?')
                        ->hidden(fn(Get $get): bool => $get('rdt_result') === false),

                    Forms\Components\Toggle::make('is_dead')
                        ->label('Is the patient dead due to malaria?')
                        ->hidden(fn(Get $get): bool => $get('rdt_result') === false),
                    Forms\Components\Select::make('symptoms')->label('Symptom Severity')
                        ->options([
                            'moderate' => 'Moderate',
                            'severe' => 'Severe',
                        ])
                        ->placeholder('Select symptom severity')
                        ->hidden(fn(Get $get): bool => $get('rdt_result') === false),
                    Forms\Components\Toggle::make('travelling_before')
                        ->label('Has the patient travelled before diagnosis?')
                        ->hidden(fn(Get $get): bool => $get('rdt_result') === false),

                    Forms\Components\Toggle::make('persons_with_disability')
                        ->label('Is the patient a disabled person?')
                        ->hidden(fn(Get $get): bool => $get('rdt_result') === false),
                    Forms\Components\Toggle::make('internally_displaced')
                        ->label('Is the patient an internally displaced person?')
                        ->hidden(fn(Get $get): bool => $get('rdt_result') === false),

                    Forms\Components\Textarea::make('remark')->columnSpanFull(),
                ])
                ->columns(1),
        ]);
    }


    public static function table(Tables\Table $table): Tables\Table
    {
        return $table->columns([
            Tables\Columns\TextColumn::make('reporter_name')
                ->description(fn(MalariaCaseReport $record): string => $record->reporter_village . ' (' . $record->reporter_township . ')')
                ->wrap()
                ->searchable(),
            Tables\Columns\TextColumn::make('reporter_id')->searchable(),
            Tables\Columns\TextColumn::make('volunteer_name')->searchable()
                ->wrap()
                ->description(fn(MalariaCaseReport $record): string => $record->volunteer_village . ' (' . $record->volunteer_township . ')'),

            Tables\Columns\TextColumn::make('test_date')->date()->sortable(),

            Tables\Columns\TextColumn::make('treatment_month')
                ->formatStateUsing(fn(string $state): string => ucfirst($state))
                ->description(fn(MalariaCaseReport $record): string => $record->treatment_year)
                ->searchable(),
            Tables\Columns\TextColumn::make('patient_name')->searchable(),
            Tables\Columns\TextColumn::make('age')
                ->formatStateUsing(fn(string $state, MalariaCaseReport $record): string => $state . ' ' . $record->age_unit . '(s)')
                ->sortable(),
            Tables\Columns\TextColumn::make('sex')
                ->formatStateUsing(fn(string $state): string => match ($state) {
                    'm' => 'Male',
                    'f' => 'Female',
                    'other' => 'Other',
                }),
            Tables\Columns\TextColumn::make('preg')
                ->formatStateUsing(fn(bool $state): string => $state ? 'Pregnant' : '')
                ->badge(),
            Tables\Columns\TextColumn::make('lact_mother')
                ->formatStateUsing(fn(bool $state): string => $state ? 'lactmother' : ''),

            Tables\Columns\TextColumn::make('address')->searchable(),

            Tables\Columns\TextColumn::make('rdt_result')
                ->formatStateUsing(fn(bool $state): string => $state ? 'Positive' : 'Negative')
                ->badge()
                ->color(fn(bool $state): string => $state ? 'danger' : 'success'),
            Tables\Columns\TextColumn::make('malaria_parasite'),
            Tables\Columns\TextColumn::make('received_treatment')
                ->formatStateUsing(fn($state): string => match ($state) {
                    '<24' => 'Within 24 Hours',
                    '>24' => 'After 24 Hours',
                }),

            Tables\Columns\TextColumn::make('is_referred')
                ->badge()
                ->color(fn(bool $state): string => $state ? '' : 'success')
                ->formatStateUsing(fn(bool $state): string => $state ? 'Referred' : ''),




            Tables\Columns\TextColumn::make('is_dead')
                ->badge()
                ->formatStateUsing(fn(bool $state): string => $state ? 'Expired' : ' ')
                ->color(fn(bool $state): string => $state ? 'danger' : 'secondary'),

            Tables\Columns\TextColumn::make('occupation')->searchable(),
            Tables\Columns\TextColumn::make('created_at')->dateTime()->sortable()->toggleable(),
            Tables\Columns\TextColumn::make('updated_at')->dateTime()->sortable()->toggleable(),

        ])
            ->filters([
                Filter::make('table-filter')
                    ->form([
                        Checkbox::make('rdt_result')
                            ->label('Show only RDT Positive')
                            ->columnSpan(1),
                        Radio::make('sex')
                            ->label('Filter by Sex')
                            ->options([
                                'm' => 'Male',
                                'f' => 'Female',
                                'other' => 'Other'
                            ])
                            ->inline()
                            ->columnSpan(1),
                    ])
                    ->columns(2)
                    ->columnSpanFull()
                    ->query(function (Builder $query, array $data) {
                        return $query
                            ->when(
                                $data['rdt_result'],
                                fn(Builder $query, $rdt_result): Builder => $query->where('rdt_result', true),
                            )
                            ->when(
                                $data['sex'],
                                function (Builder $query, $sex): Builder {
                                    if ($sex === 'm') {
                                        return $query->where('sex', 'm');
                                    } else if ($sex === 'f') {
                                        return $query->where('sex', 'f');
                                    } else {
                                        return $query->where('sex', 'other');
                                    }
                                }
                            );
                    })
                // TernaryFilter::make('rdt_result')
                //     ->label('Show only RDT Positive'),

                // SelectFilter::make('sex')
                //     ->label('Gender')
                //     ->options([
                //         'm' => 'Male',
                //         'f' => 'Female',
                //         'other' => 'Other',
                //     ])
            ], layout: FiltersLayout::AboveContent);
    }


    public static function getPages(): array
    {
        return [
            'index' => Pages\ListMalariaCaseReports::route('/'),
            'create' => Pages\CreateMalariaCaseReport::route('/create'),
            'edit' => Pages\EditMalariaCaseReport::route('/{record}/edit'),
        ];
    }
}
