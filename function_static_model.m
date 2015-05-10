function [ next_step_predicted_value ] = function_static_model( original_values, time_step, sample_rate )
      next_step_predicted_value = 50*sin(2*pi*10*((time_step*sample_rate)/sample_rate));
end

