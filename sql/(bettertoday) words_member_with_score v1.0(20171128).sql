CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `lastkiss`@`%` 
    SQL SECURITY DEFINER
VIEW `words_member_with_score` AS
    SELECT 
        `mwh`.`member_id` AS `member_id`,
        `member`.`passwd` AS `passwd`,
        `member`.`can_make_question` AS `can_make_question`,
        COALESCE((SELECT 
                        AVG(`mwh2`.`score`)
                    FROM
                        `member_word_history` `mwh2`
                    WHERE
                        ((`mwh2`.`date_created` >= (NOW() - INTERVAL 30 DAY))
                            AND (`mwh`.`member_id` = `mwh2`.`member_id`))),
                0) AS `avg_30`,
        COALESCE((SELECT 
                        AVG(`mwh2`.`score`)
                    FROM
                        `member_word_history` `mwh2`
                    WHERE
                        ((`mwh2`.`date_created` <= (NOW() - INTERVAL 31 DAY))
                            AND (`mwh2`.`date_created` >= (NOW() - INTERVAL 60 DAY))
                            AND (`mwh`.`member_id` = `mwh2`.`member_id`))),
                0) AS `avg_31_to_60`,
        COALESCE((SELECT 
                        AVG(`mwh2`.`score`)
                    FROM
                        `member_word_history` `mwh2`
                    WHERE
                        ((`mwh2`.`date_created` <= (NOW() - INTERVAL 61 DAY))
                            AND (`mwh2`.`date_created` >= (NOW() - INTERVAL 90 DAY))
                            AND (`mwh`.`member_id` = `mwh2`.`member_id`))),
                0) AS `avg_61_to_90`,
        COALESCE((SELECT 
                        AVG(`mwh2`.`score`)
                    FROM
                        `member_word_history` `mwh2`
                    WHERE
                        ((`mwh2`.`date_created` <= (NOW() - INTERVAL 91 DAY))
                            AND (`mwh`.`member_id` = `mwh2`.`member_id`))),
                0) AS `avg_91_plus`
    FROM
        (`member_word_history` `mwh`
        JOIN `words_member` `member` ON ((`mwh`.`member_id` = `member`.`member_id`)))
    GROUP BY `mwh`.`member_id`
    ORDER BY `mwh`.`date_created` DESC
    LIMIT 100