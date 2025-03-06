<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration {
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('malaria_case_reports', function (Blueprint $table) {
            // Primary Key
            $table->id();

            // Test Information
            $table->date('test_date');

            //Treatment information
            $table->string('treatment_month');
            $table->string('treatment_year');



            // Patient Information
            $table->string('patient_name');
            $table->enum('age_unit', ['day', 'month', 'year'])->default('year');
            $table->integer('age')->unsigned();

            $table->enum('sex', ['m', 'f', 'other'])->nullable();
            $table->boolean('preg')->default(false);
            $table->boolean('lact_mother')->default(false);

            $table->string('address');

            // Test Results
            $table->boolean('rdt_result')->default(false);
            $table->enum('malaria_parasite', ['pf', 'pv', 'mixed'])->nullable();
            $table->enum('received_treatment', ['<24', '>24'])->nullable();

            // Treatment Information
            $table->boolean('act24')->default(false);
            $table->decimal('act24_amount', 3, 1)->nullable();
            $table->boolean('act18')->default(false);
            $table->decimal('act18_amount', 3, 1)->nullable();
            $table->boolean('act12')->default(false);
            $table->decimal('act12_amount', 3, 1)->nullable();
            $table->boolean('act6')->default(false);
            $table->decimal('act6_amount', 3, 1)->nullable();
            $table->boolean('cq')->default(false);
            $table->decimal('cq_amount', 3, 1)->nullable();
            $table->boolean('pq')->default(false);
            $table->decimal('pq_amount', 3, 1)->nullable();
            $table->boolean('is_referred')->default(false);
            $table->boolean('is_dead')->default(false);
            $table->enum('symptoms', ['moderate', 'severe'])->nullable();


            // Additional Information
            $table->boolean('travelling_before')->default(false);
            $table->boolean('persons_with_disability')->default(false);
            $table->boolean('internally_displaced')->default(false);
            $table->string('occupation')->nullable();

            // Volunteer Information (Foreign Key)
            $table->string('volunteer_name');
            $table->string('volunteer_township');
            $table->string('volunteer_village');


            // Remarks
            $table->text('remark')->nullable();


            //reporter name

            $table->string('reporter_name');
            $table->string('reporter_id');
            $table->string('reporter_village');
            $table->string('reporter_township');
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('malaria_case_reports');
    }
};
