CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `lastkiss`@`%` 
    SQL SECURITY DEFINER
VIEW `words_member_with_score10` AS
    SELECT 
        `mwh`.`member_id` AS `member_id`,
        `member`.`passwd` AS `passwd`,
        `member`.`can_make_question` AS `can_make_question`,
        COALESCE((SELECT 
                        AVG(`mwh3`.`score`)
                    FROM
                        (SELECT * from `member_word_history` mwh2
                         WHERE ((`mwh2`.`date_created` >= (NOW() - INTERVAL 30 DAY))
                            )
                         ORDER BY `mwh2`.`date_created` DESC LIMIT 10
                         ) `mwh3`
                    ),
                0) AS `avg_30`,
        COALESCE((SELECT 
                        AVG(`mwh3`.`score`)
                    FROM
                        (SELECT * from `member_word_history` mwh2
                         WHERE
                         ((`mwh2`.`date_created` <= (NOW() - INTERVAL 31 DAY))
                            AND (`mwh2`.`date_created` >= (NOW() - INTERVAL 60 DAY))
                            )
                         ORDER BY `mwh2`.`date_created` DESC LIMIT 10
                         ) `mwh3`
                    ),
                0) AS `avg_31_to_60`,
        COALESCE((SELECT 
                        AVG(`mwh3`.`score`)
                    FROM
                        (SELECT * from `member_word_history` mwh2
                         WHERE
                         ((`mwh2`.`date_created` <= (NOW() - INTERVAL 61 DAY))
                            AND (`mwh2`.`date_created` >= (NOW() - INTERVAL 90 DAY))
                            )
                         ORDER BY `mwh2`.`date_created` DESC LIMIT 10) `mwh3`
                    ),
                0) AS `avg_61_to_90`,
        COALESCE((SELECT 
                        AVG(`mwh3`.`score`)
                    FROM
                        (SELECT * from `member_word_history` mwh2
                         WHERE
                        ((`mwh2`.`date_created` <= (NOW() - INTERVAL 91 DAY))
                            )
                         ORDER BY `mwh2`.`date_created` DESC LIMIT 10) `mwh3`
                    ),
                0) AS `avg_91_plus`
    FROM
        (`member_word_history` `mwh`
        JOIN `words_member` `member` ON ((`mwh`.`member_id` = `member`.`member_id`)))
    GROUP BY `mwh`.`member_id`