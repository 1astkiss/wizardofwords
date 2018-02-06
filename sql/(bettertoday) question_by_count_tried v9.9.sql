CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `lastkiss`@`%` 
    SQL SECURITY DEFINER
VIEW `bettertoday`.`question_by_count_tried` AS
    SELECT 
        `mwh`.`question_id` AS `question_id`,
        `q`.`word` AS `word`,
        `q`.`selection1` AS `selection1`,
        `q`.`selection2` AS `selection2`,
        `q`.`selection3` AS `selection3`,
        `q`.`selection4` AS `selection4`,
        `q`.`answer` AS `answer`,
        `q`.`weight` AS `weight`
    FROM
        (`bettertoday`.`member_word_history` `mwh`
        JOIN `bettertoday`.`questions_with_weight` `q` ON ((`mwh`.`question_id` = `q`.`question_id`)))
    WHERE
        (`mwh`.`count_tried` = 1)