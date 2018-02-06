CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `bettertoday`.`question_correct_by_level` AS
    SELECT 
        `mwh`.`question_id` AS `question_id`,
        `mwh`.`member_level` AS `member_level`,
        COUNT(0) AS `try_sum`,
        (SELECT 
                COUNT(0)
            FROM
                `bettertoday`.`member_word_history` `mwh2`
            WHERE
                ((`mwh2`.`question_id` = `mwh`.`question_id`)
                    AND (`mwh2`.`member_level` = `mwh`.`member_level`)
                    AND (`mwh2`.`count_tried` = 1))) AS `try_1st`,
        (((SELECT 
                COUNT(0)
            FROM
                `bettertoday`.`member_word_history` `mwh2`
            WHERE
                ((`mwh2`.`question_id` = `mwh`.`question_id`)
                    AND (`mwh2`.`member_level` = `mwh`.`member_level`)
                    AND (`mwh2`.`count_tried` = 1))) / COUNT(0)) * 100) AS `ratio_1st`
    FROM
        `bettertoday`.`member_word_history` `mwh`
    GROUP BY `mwh`.`question_id` , `mwh`.`member_level`