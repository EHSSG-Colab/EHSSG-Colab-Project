<?php

namespace App\Http\Controllers\Api;

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Auth;
use App\Http\Controllers\Api\ApiController;

class LoginController extends ApiController
{
    public function login(Request $request)
    {
        if (Auth::attempt([
            'email' => $request->email,
            'password' => $request->password,
        ])) {
            $user = Auth::user();
            $result['token'] = $user->createToken('token')->plainTextToken;
            $result['user_id'] = $user->id;
            $result['name'] = $user->name;
            return $this->sendResponse($result, 'Logged in successfully.');
        } else {
            return $this->sendError('Authorization Failed', 'Invalid login credentials', 403);
        }
    }
}
