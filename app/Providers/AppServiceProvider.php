<?php

namespace App\Providers;

use URL;
use Illuminate\Support\ServiceProvider;

class AppServiceProvider extends ServiceProvider
{
    /**
     * Register any application services.
     */
    public function register(): void
    {
        //
    }

    /**
     * Bootstrap any application services.
     */
    public function boot(): void
    {
        \URL::forceRootUrl(config('app.url'));

        // If using a subdirectory
        \URL::forceScheme('https');

        // You might also need this to handle the subdirectory
        $this->app['request']->server->set('SCRIPT_NAME', '/internship/25-01/index.php');
    }
}
