function [ next_step_predicted_value ] = function_var_model( original_values, time_step, sample_rate )
      %Autoregressive model (5 order) of first 2 second 'Y' data have next coeficients
      % You can use 'ar' for calculate coeficients and 'getpvec' for getting coefficients from idpody model 
      ar_coef=[-2.3; 1.8; 0.7; -1.6; 0.8]; %pre avalueated
      values_amount = size(original_values,2);
      if values_amount>=size(ar_coef,1)
          next_step_predicted_value = -ar_coef(1)*original_values(values_amount) -ar_coef(2)*original_values(values_amount-1)          -ar_coef(3)*original_values(values_amount-2)          -ar_coef(4)*original_values(values_amount-3)          -ar_coef(5)*original_values(values_amount-4);
      else
          next_step_predicted_value =0;
      end
end