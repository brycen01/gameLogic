clc
clear all
fprintf("starting\n")
% e for empty
% x for x
% o for o

% [e,e,e;
%  e,x,e;
%  e,e,e;]
inArray = ['x', 'e', 'x';
           'o', 'o', 'e';
           'x', 'e', 'o'];

return_position = 0;

% GENERALLY ASSUME ALL LOWER NUMBERS REPRESENT 
% PLAYER 1 AND HIGHER NUMBERS REPRESENT PLAYER 2

% first_turn_party indicates who started the game
% 0 - Human opponent
% 1 - Our robot
first_turn_party = 1;
if(first_turn_party == 0)
    p1 = 'Human';
    p2 = 'Robot';
else
    p2 = 'Human';
    p1 = 'Robot';
end
fprintf("%s starts the game!\n", p1)
current_turn = first_turn_party;
current_player = p1;

% Take in a 3x3 array and return a position on grid

%% INITIAL CHECK
% First check if game is won
    % 0 - game not won
    % 1/2 - game over, 1 indicates the user won, 2 indicates our robot won
    % return out of function and provide final win value
winner = gameWon(inArray);
if(winner ~= 0)
    if(winner == 1)
        fprintf("Game won by %s!\n", p1)
    else
        fprintf("Game won by %s!\n", p2)
    end
    return; 
else
    fprintf("Game continuing...\n")
end
%% PLAYER TURNS
% If we made it here that means no one has won
% therefore check who's turn it is
if(current_turn == 0)
    % This represents the humans turn, which we can't implement logic for
    % have a function for doing something maybe?
    % for right now just assume they insert something and switch turn
    current_turn = mod(current_turn, 1);
    fprintf("Robot may now place a piece\n")
else
    % this represents the robots turn
    % this will be long and complicated
    
    % highest priority is checking for our own tic tac toes
    if(first_turn_party == 0)
        our_toe = toe_poss(inArray, 'o');
        their_toe = toe_poss(inArray, 'x');
    else
        our_toe = toe_poss(inArray, 'x');
        their_toe = toe_poss(inArray, 'o');
    end

    fprintf("Our possible tic tac toe position: %i\n", our_toe)
    fprintf("Enemy possible tic tac toe position: %i\n", their_toe)
    if(our_toe ~= 0)
        return_position = our_toe;
        return;
    elseif(their_toe ~= 0)
        return_position = their_toe;
        return;

    % if we made it this far there are no possible toes
    % therefore prioritize corners, then middle, then edges
    % placing adjacent pieces if possible to form toes

    % second priority is preventing their tic tac toes
    current_turn = mod(current_turn, 1);
    fprintf("Human may now place a piece\n")
    
end


%% Possible tic tacc toes function
function position = toe_poss(inArray, char)
    % char represents if were looking for x toes or o toes
    fprintf("Looking for %c toes\n", char)
    % for possible toes we need a line with 2 of the desired char and an e
    
    % checks rows for possible toes
    for x = 1:3
        char_cnt = row_cnt(inArray, x, char);
        e_cnt = row_cnt(inArray, x, 'e');
        if(char_cnt == 2 && e_cnt == 1)
            % return position of the e
            for y = 1:3
                if(inArray(x,y) == 'e')
                    position = 3*(x-1)+y;
                    return;
                end
            end
        end
    end
    
    for y = 1:3
        char_cnt = col_cnt(inArray, y, char);
        e_cnt = col_cnt(inArray, y, 'e');
        if(char_cnt == 2 && e_cnt == 1)
            % return position of the e
            for x = 1:3
                if(inArray(x,y) == 'e')
                    position = 3*(x-1)+y;
                    return;
                end
            end
        end
    end
    
    % check dags for possible toes
    for dag_num = 1:2
        char_cnt = dag_cnt(inArray, dag_num, char);
        e_cnt = dag_cnt(inArray, dag_num, 'e');
        if(char_cnt == 2 && e_cnt == 1)
            % return position of the e
            if(dag_num == 1)
                for x = 1:3
                    if(inArray(x,x) == 'e')
                        position = x*x;
                        return;
                    end
                end
            elseif(dag_num == 2)
                for x = 1:3
                    if(inArray(x, 4-x) == 'e')
                        if(x == 1)
                            position = 3;
                        elseif(x == 2)
                            position = 5;
                        else
                            position = 7;
                        end
                        return;
                    end
                end
            end
        end
    end
   
    position = 0;
end
%% GAME WON FUNCTION
function result = gameWon(inArray)
% INDEXING IS (row, column)
    % check each row for three of a symbol
    for x = 1:3
        if(row_cnt(inArray, x, 'x') == 3)
            result = 1;
            return;
        elseif(row_cnt(inArray, x, 'o') == 3)
            result = 2;
            return;
        end
    end
    % check each column for three of a symbol
    for x = 1:3
        if(col_cnt(inArray, x, 'x') == 3)
            result = 1;
            return;
        elseif(col_cnt(inArray, x, 'o') == 3)
            result = 2;
            return;
        end
    end
    % check each diagonal for three of a symbol
   for x = 1:2
        if(dag_cnt(inArray, x, 'x') == 3)
            result = 1;
            return;
        elseif(dag_cnt(inArray, x, 'o') == 3)
            result = 2;
            return;
        end
   end
   result = 0;
end
            

            
function char_cnt = row_cnt(inArray, x, char)
    char_cnt = 0;
    % count amt of char in desired row
    for y = 1:3
         if(inArray(x,y) == char)
                char_cnt = char_cnt + 1;
         end
    end
end

function char_cnt = col_cnt(inArray, y, char)
    char_cnt = 0;
    % count amt of char in desired col
    for x = 1:3
         if(inArray(x,y) == char)
                char_cnt = char_cnt + 1;
         end
    end
end

function char_cnt = dag_cnt(inArray, dag_num, char)
    char_cnt = 0;
    % count amt of char in desired dag
    if(dag_num == 1)
        for x = 1:3
            if(inArray(x,x) == char)
                char_cnt = char_cnt + 1;
            end
        end
    else
        for x = 1:3
            if(inArray(x,4-x) == char)
                char_cnt = char_cnt + 1;
            end
        end
    end
end