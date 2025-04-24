<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use App\Models\MalariaCaseReport;
use App\Http\Controllers\Controller;
use App\Http\Controllers\Api\ApiController;

class MalariaCaseReportController extends ApiController
{
    public function index(Request $request)
    {
        $malariaCases= MalariaCaseReport::all();
        return $malariaCases;
    }

}
