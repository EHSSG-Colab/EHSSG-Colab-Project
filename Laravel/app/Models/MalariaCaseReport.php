<?php

namespace App\Models;

use Illuminate\Database\Eloquent\Model;

class MalariaCaseReport extends Model
{
    protected $fillable = [
        'test_date',
        'treatment_month',
        'treatment_year',
        'patient_name',
        'age_unit',
        'age',
        'sex',
        'preg',
        'lact_mother',
        'address',
        'rdt_result',
        'malaria_parasite',
        'received_treatment',
        'act24',
        'act24_amount',
        'act18',
        'act18_amount',
        'act12',
        'act12_amount',
        'act6',
        'act6_amount',
        'cq',
        'cq_amount',
        'pq',
        'pq_amount',
        'is_referred',
        'is_dead',
        'symptoms',
        'travelling_before',
        'persons_with_disability',
        'internally_displaced',
        'occupation',
        'volunteer_name',
        'volunteer_village',
        'volunteer_township',
        'remark',
        'reporter_name',
        'reporter_id',
        'reporter_village',
        'reporter_township',
    ];
    protected function casts(): array
    {
        return [

            'preg' => 'boolean',
            'lact_mother' => 'boolean',
            'rdt_result' => 'boolean',
            'act24' => 'boolean',
            'act18' => 'boolean',
            'act12' => 'boolean',
            'act6' => 'boolean',
            'cq' => 'boolean',
            'pq' => 'boolean',
            'is_refered' => 'boolean',
            'is_dead' => 'boolean',
            'travelling_before' => 'boolean',
            'persons_with_disability' => 'boolean',
            'internally_displaced' => 'boolean',
        ];
    }
}
