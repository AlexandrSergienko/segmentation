function [segments, errors, predited_values]=segmentation(Y, window_size, threshold, sample_rate, functions)
% Function segmentation separete 'Y' data accordinly with prediction models
% that you need to specify as 'functions'.
% Every function used for predit next step of 'Y' process and those
% function that have least error in 'window_size' will be represented in
% 'segments' in order number of this function.
%
% Function must have next structure of in/out parameters:
%
% function [ next_step_predicted_value ] = function_model_name( original_values, time_step, sample_rate )
%     %This function used for prediction next value of time series values 
%     %named original_values.
%     %time_step starts from 1/sample_rate
%     next_step_predicted_value = some operation with original values or
%     with time step and frequency...
% end
%
% You can specify a 'threshold' and if no models have least mean square
% error in 'window_size' than less than 'threshold', than in 'segments' you
% can see representation as 0 order number.
%
% For example:
% 
% sample_rate = 100;
% t=0:1/sample_rate:10;%10 seconds
% frequency = 10; %Hz
% window_size = 64;
% threshold = 999999999;
% Y = (50+100*exp(-t)).*sin(2*pi*frequency*t);
% 
% Models functions:
% 
% One function for detection static amplitude (save as function .m file)
% function [ next_step_predicted_value ] = function_static_model( original_values, time_step, sample_rate )
%     %This function used for prediction next value of time series values 
%     %named original_values.
%     %time_step starts from 1/sample_rate.
%     next_step_predicted_value = 50*sin(2*pi*10*time_step);
% end
%
% Other function for detection exp amplitude changing (save as function .m
% file)
% function [ next_step_predicted_value ] = function_var_model( original_values, time_step, sample_rate )
%     %Autoregressive model (5 order) of first 2 second 'Y' data have next coeficients
%     % You can use 'ar' for calculate coeficients and 'getpvec' for getting coefficients from idpody model 
%     ar_coef=[-2.3; 1.8; 0.7; -1.6; 0.8]; %pre avalueated
%     values_amount = size(original_values,2);
%     if values_amount>=size(ar_coef,1)
%         next_step_predicted_value = -ar_coef(1)*original_values(values_amount) -ar_coef(2)*original_values(values_amount-1)          -ar_coef(3)*original_values(values_amount-2)          -ar_coef(4)*original_values(values_amount-3)          -ar_coef(5)*original_values(values_amount-4);
%     else
%         next_step_predicted_value = 0;
%     end
% end
%
% plot(Y)
% functions={@function_static_model @function_var_model};
% [segments, errors, predited_values]=segmentation(Y, window_size,
% threshold, sample_rate, functions);
% plot(segments)%You can see order number of model that more fit to
% original signal.


predited_values = zeros(size(Y,2),size(functions,2));
segments =  zeros(size(Y,2),1);
errors= zeros(size(Y,2),size(functions,2));
segment_number=1;
model_number_with_min_error = 0;
model_min_error = 0;
for i=1:size(Y,2)-1
    init_position = i-50;
    if init_position<1
        init_position = 1;
    end 
    window = Y(init_position:i);
    for j=1:size(functions,2)
        s = functions{j};
        predited_values(i+1,j)=s(window, i/sample_rate, sample_rate);
        errors(i+1,j) = predited_values(i+1,j)-Y(i+1);
    end
    if segment_number==i/window_size 
        mine=9999999999999;%min error
        init_position=i-window_size;
        if init_position<1
            init_position = 1;
        end 
        for j=1:size(functions,2)       
            least_square_error=mse(errors(init_position:i,j));
            if least_square_error<mine
                mine=least_square_error;
                model_min_error = mine;
                model_number_with_min_error = j;
            end
        end   
        segment_number=segment_number+1;
    end
    if model_min_error<threshold
        segments(i) = model_number_with_min_error;
    else
        segments(i) = 0;
    end
end

end