<?php

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;
use App\Http\Controllers\Api\LoginController;
use App\Http\Controllers\Api\MalariaCaseReportController;

Route::get('/user', function (Request $request) {
    return $request->user();
})->middleware('auth:sanctum');

Route::post('login', [LoginController::class, 'login']);
Route::get('malaria-case-reports', [MalariaCaseReportController::class, 'index']);


Route::middleware('auth:sanctum')->group(function () {
    Route::get('malaria-case-reports', [MalariaCaseReportController::class, 'index']);
});
