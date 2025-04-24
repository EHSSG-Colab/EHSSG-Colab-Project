<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Response;

class ApiController extends Controller
{
    public function sendResponse($result, $message)
    {
        $response = [
            'success' => true,
            'info' => $result,
            'message' => $message,
        ];
        return response()->json($response, 200);
    }

    public function sendError($error, $errorDescription, $status)
    {
        $response = [
            'success' => false,
            'info' => $errorDescription ?? 'An error has occured.',
            'message' => $error,
        ];
        return response()->json($response, $status);
    }
}
