use ipl;
select * from ipl_bidder_details;
select * from ipl_bidder_points;
select * from ipl_bidding_details;
select * from ipl_match;
select * from ipl_match_schedule;
select * from ipl_player;
select * from ipl_stadium;
select * from ipl_team;
select * from ipl_team_players;
select * from ipl_team_standings;
select * from ipl_tournament;
select * from ipl_user;

-- 1.	Show the percentage of wins of each bidder in the order of highest to lowest percentage.
select bd.bidder_id, (count(bd.bid_status)/bp.no_of_bids)*100  'win percentage'
 from ipl_bidding_details bd, ipl_bidder_points bp
where  bd.bid_status = 'won' and bd.bidder_id = bp.bidder_id
group by bidder_id
order by 2 desc;

-- 2.	Display the number of matches conducted at each stadium with stadium name,city from the database.
select s.stadium_id, s.stadium_name, s.city,trm.tournmt_name , sum(trm.total_matches) num_of_matches
from ipl_stadium s inner join ipl_match_schedule mc
on s.stadium_id = mc.stadium_id
inner join ipl_tournament trm
on mc.tournmt_id = trm.tournmt_id
group by s.stadium_id;


-- 3.	In a given stadium, what is the percentage of wins by a team which has won the toss?
select s.stadium_name,
(sum((Case when Toss_winner = Match_winner then 1 else 0 end))/count(*) )*100  'percentage_win_by_team'
from ipl_match im inner join ipl_match_schedule ims
on im.match_id = ims.match_id
inner join ipl_stadium s
on ims.stadium_id = s.stadium_id
group by s.stadium_name
order by 1;

-- 4.	Show the total bids along with bid team and team name.
select t.team_id, t.team_name, count(bd.bid_team) total_bids 
from ipl_bidding_details bd inner join ipl_team t
on bd.bid_team = t.team_id
group by t.team_name;

-- 5.	Show the team id who won the match as per the win details.
select m. team_id1, m.team_id2, m.match_winner, m.win_details,
ifnull( (CASE 
                WHEN m.match_winner=1  THEN
                     m.team_id1
                WHEN  m.match_winner=2 THEN
                      m.team_id2
                 END) , m.match_winner) as team_id_as_per_windetails
from ipl_match m inner join ipl_team t
on m.team_id1 = t.team_id
;

-- 6.	Display total matches played, total matches won and total matches lost by team along with its team name.
select ts.team_id, sum(ts.matches_played) match_played, sum(ts.matches_won) match_won, 
sum(ts.matches_lost) match_lost, t.team_name
from ipl_team_standings ts inner join ipl_team t
on ts.team_id = t.team_id
group by t.team_name;

-- 7.	Display the bowlers for Mumbai Indians team.
select t.team_id, t.team_name, tp.player_role, p.player_id, p.player_name
from ipl_player p inner join ipl_team_players tp
on p.player_id = tp.player_id
inner join ipl_team t
on tp.team_id = t.team_id
where  t.team_name="Mumbai Indians" and  tp.player_role="Bowler"   ;

-- 8.	How many all-rounders are there in each team, Display the teams with more than 4 
-- all-rounder in descending order
select t.team_id, t.team_name, tp.player_role,count(tp.player_role) more_than4_allrounder
from ipl_team_players tp inner join ipl_team t
on tp.team_id = t.team_id
where tp.player_role="All-Rounder"
group by t.team_name
having count(tp.player_role)>4
order by count(tp.player_role ) desc ;







