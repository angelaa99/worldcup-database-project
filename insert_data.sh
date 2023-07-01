#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "TRUNCATE TABLE games, teams")

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do

  # INSERT TEAMS TABLE NAME
  # GET WINNER NAME
  
  if [[ $WINNER != "winner" ]]
    then
      TEAMS=$($PSQL "SELECT name FROM teams WHERE name='$WINNER'")
        if [[ -z $TEAMS ]]
          then
            INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
              if [[ INSERT_TEAM == "INSERT 0 1" ]]
                then
                  echo Inserted teams $WINNER
              fi
        fi
  fi

  # GET OPPONENT NAME

  if [[ $OPPONENT != "opponent" ]]
    then
      TEAMS2=$($PSQL "SELECT name FROM teams WHERE name='$OPPONENT'")
        if [[ -z $TEAMS2 ]]
          then
            INSERT_TEAM2=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
              if [[ INSERT_TEAM2 == "INSERT 0 1" ]]
                then
                  echo Inserted teams $OPPONENT
              fi
        fi
  fi

  # INSERT GAMES TABLE DATA

    if [[ YEAR != "year" ]]
      then
        WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER'")
        OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT'")
        INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES ($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS)")
          if [[ INSERT_GAME == "INSERT 0 1" ]]
            then
              echo New game added: $YEAR, $ROUND, $WINNER_ID VS $OPPONENT_ID, score $WINNER_GOALS: $OPPONENT_GOALS
          fi
    fi
done
