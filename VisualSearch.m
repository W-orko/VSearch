%% Warish Orko 5/31/19
% Visual Search Paradigm simulator
% This script carries out a visual paradigm test as seen in Treisman and Gelade
% 1980. The two types of tests are Pop-Out tests, where the user
% looks for the black X in the absence of other black items, and
% Conjunction tests where there are black O's present as well. The program
% outputs a graph of the reaction times for correct responses for each type
% of test.


%%  Initialization

% Pre-allocating variables
n_hastarget = 0; % Number of trials that have the target present.
n_correct = 0; % Number of correct responses.
n_wrong = 0; % Number of incorrect responses.
times_correct_pop = []; % Reaction times for correct responses to the pop-out tests
times_wrong_pop = []; % Reaction times for incorrect responses to the pop-out tests
times_correct_conj = []; % Reaction times for correct responses to the conjunction tests
times_wrong_conj = []; % Reaction times for incorrect responses to the conjunction tests
sizes_correct_pop = [];
sizes_correct_conj = [];

% Pop-up to start the test
f = msgbox('Press return to start the test. If you see a black X, press the left arrow key. If you do not, press the right arrow key.'); % Creates a pop-up asking for the user to start the test. This prevents initial responses from having bias.
uiwait(f); % Wait until the user closes the dialog box.

%% Pop-out Tests
for i = 1:4 % i is the counter to help determine the total number of elements on screen, choosing from 4, 8, 12 and 16.
    for ii = 1:5 % ii is the counter for the number of trials at each level of elements, i.e. at the 4-element level, there are 5 trials.
        clf; % Clear any existing figure
        test_hastarget = randi(2,1); % Randomly determine on a 50% chance if this trial contains the target element.
        if test_hastarget == 2 % 2 = has the target, 1 = does not
            num_total = i*4-1; % The number of total elements is a multiple of 4, this variable stores the number of non-target elements.
            num_x = floor(num_total/2); % Half the number of elements, rounded down, are X's
            num_o = num_total-num_x; % The rest are O's.
            n_hastarget = n_hastarget + 1; % Register that one additional trial with the target present has been conducted.
            scatter( rand(1, num_o), rand(1,num_o), 90, 'r' ); % Generate randomly distributed red O's
            hold on
            scatter( rand(1,num_x), rand(1,num_x), 90, 'r', 'x' ); % Generate randomly distributed red X's
            scatter( rand(1,1), rand(1,1), 90, 'black', 'x'); % Generate the target element
            tic; % Start measuring the time taken for the user to recognize the target
            k = waitforbuttonpress;
            key = double(get(gcf,'CurrentCharacter')); % Checks what key the user has pressed.
            if key == 28 %28 is left arrow, indicates a YES
                n_correct = n_correct + 1; % Record one more correct answer
                x = toc; % Stop timing
                times_correct_pop = [times_correct_pop x]; % Add the time to the records
                sizes_correct_pop = [sizes_correct_pop i*4]; % Add set size to the records
            else %Any key that is not the left arrow counts as a NO.
                n_wrong = n_wrong + 1;
                x = toc;
                times_wrong_pop = [times_wrong_pop x];
            end    
        else % No target is present
        num_total = i*4;
        num_x = floor(num_total/2);
        num_o = num_total-num_x;
        scatter( rand(1,num_o), rand(1,num_o), 90, 'r' ); 
        hold on
        scatter( rand(1,num_x), rand(1,num_x), 90, 'r', 'x' );
        tic;
        k = waitforbuttonpress;
        key = double(get(gcf,'CurrentCharacter'));
        if key == 29 
            n_correct = n_correct + 1;
             x = toc;
             times_correct_pop = [times_correct_pop x];
             sizes_correct_pop = [sizes_correct_pop i*4];
        elseif key == 28 
            n_wrong = n_wrong + 1;
            x = toc;
            times_wrong_pop = [times_wrong_pop x];
        end
        end
    end
end

%% Conjunction Tests

for i = 1:4
    for ii = 1:5
        clf;
        test_hastarget = randi(2,1);
        if test_hastarget == 2 % Target is present
            num_total = i*4-1;
            num_x = floor(num_total/2);
            num_o = num_total-num_x;

            n_hastarget = n_hastarget + 1;

            scatter( rand(1, num_o/2), rand(1,num_o/2), 90, 'r' ); % Non-target O's
            hold on
            scatter( rand(1, num_o/2), rand(1,num_o/2), 90, 'black'); % Target-colored O's
            scatter( rand(1,num_x), rand(1,num_x), 90, 'r', 'x' ); % Non-target X's
            scatter( rand(1,1), rand(1,1), 90, 'black', 'x'); % Target colored X, the actual target
            tic;
            k = waitforbuttonpress;
            key = double(get(gcf,'CurrentCharacter'));
            if key == 28 % 28 is left arrow, indicates a YES
                n_correct = n_correct + 1;
                x = toc;
                times_correct_conj = [times_correct_conj x];
                sizes_correct_conj = [sizes_correct_conj i*4];
            else % Any other key indicates a NO
                n_wrong = n_wrong + 1;
                x = toc;
                times_wrong_conj = [times_wrong_conj x];
            end    
        else % No target present
        num_total = i*4;
        num_x = floor(num_total/2);
        num_o = num_total-num_x;
        scatter( rand(1, num_o/2), rand(1,num_o/2), 90, 'r' ); % Non-target O's
        hold on
        scatter( rand(1, num_o/2), rand(1,num_o/2), 90, 'black'); % Target-colored O's
        scatter( rand(1,num_x), rand(1,num_x), 90, 'r', 'x' ); % Non-target X's
        tic;
        k = waitforbuttonpress;
        key = double(get(gcf,'CurrentCharacter'));
        if key == 29 
            n_correct = n_correct + 1;
             x = toc;
             times_correct_conj = [times_correct_conj x];
             sizes_correct_conj = [sizes_correct_conj i*4];
        elseif key == 28 
            n_wrong = n_wrong + 1;
            x = toc;
            times_wrong_conj = [times_wrong_conj x];
        end
        end
    end
end

%% Test statistics
close all % Close the figure
total_trials = n_correct+n_wrong; % Calculate the number of trials taken
percent_score = n_correct/total_trials * 100; % Calculate the % of trials that were correct
A = [times_correct_pop.' sizes_correct_pop.'];
B = [times_correct_conj.' sizes_correct_conj.'];
[r_pop, p_pop] = corrcoef(A);
[r_conj, p_conj] = corrcoef(B);

% Display results
disp(['Results: Out of ' num2str(total_trials) ' trials, you got ' num2str(n_correct) ' correct and ' num2str(n_wrong) ' wrong.']);
disp(['You scored ' num2str( percent_score) '%.']); 
disp(['The average time on the pop-out test was ' num2str(mean(times_correct_pop)) ' seconds.'])
disp(['The average time on the conjunction test was ' num2str(mean(times_correct_conj)) ' seconds.'])
if r_pop(1,2) > 0 && p_pop(1,2) < 0.05
    disp(['There is a statistically significant positive correlation (p = ' num2str(p_conj(1,2)) ') between element set size and reaction times in the pop-out test.']);
elseif r_pop(1,2) < 0 && p_pop(1,2) < 0.05
    disp(['There is a statistically significant negative correlation (p = ' num2str(p_conj(1,2)) ') between element set size and reaction times in the pop-out test.']);
else
    disp('There is no statistically significant correlation between element set size and reaction times in the pop-out test.');
end
if r_conj(1,2) > 0 && p_conj(1,2) < 0.05
    disp('[There is a statistically significant positive correlation (p = ' num2str(p_conj(1,2)) ') between element set size and reaction times in the conjunction test.']);
elseif r_conj(1,2) < 0 && p_conj(1,2) < 0.05
    disp(['There is a statistically significant negative correlation (p = ' num2str(p_conj(1,2)) ') between element set size and reaction times in the conjunction test.']);
else
    disp('There is no statistically significant correlation between element set size and reaction times in the conjunction test.');
end



% Plot reaction times
% clf
% plot(times_correct_pop, 'LineWidth', 3, 'Color', 'r')
% hold on
% plot(times_correct_conj, 'LineWidth', 3, 'Color', 'b')
% legend('Pop-Out','Conjunction')
clf
scatter(sizes_correct_pop,times_correct_pop,'s','DisplayName','Pop-Out')
hold on
scatter(sizes_correct_conj,times_correct_conj,'DisplayName','Conjunction')
f = fit(sizes_correct_pop.',times_correct_pop.','poly1');
a = plot(f);
set(a,'Color','b');
f = fit(sizes_correct_conj.',times_correct_conj.','poly1');
plot(f);
legend('Pop-Out','Conjunction','Pop-Out Linear Fit','Conjunction Linear Fit')
xlabel('Element Set Size')
ylabel('Reaction time (s)')
title('Effect of element set size on reaction times for Pop-Out and Conjunction tests')