CREATE 
    ALGORITHM = UNDEFINED 
    DEFINER = `root`@`localhost` 
    SQL SECURITY DEFINER
VIEW `question_weight` AS
    SELECT 
        `qcbl`.`question_id` AS `question_id`,
        `q`.`word` AS `word`,
        `q`.`selection1` AS `selection1`,
        `q`.`selection2` AS `selection2`,
        `q`.`selection3` AS `selection3`,
        `q`.`selection4` AS `selection4`,
        `q`.`answer` AS `answer`,
        (100 - ((((((((((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        `question_correct_by_level` `qcbl2`
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 1))),
                0) * 0.09) * 2) + ((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        `question_correct_by_level` `qcbl2`
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 2))),
                0) * 0.08) * 2)) + ((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        `question_correct_by_level` `qcbl2`
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 3))),
                0) * 0.07) * 2)) + ((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        `question_correct_by_level` `qcbl2`
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 4))),
                0) * 0.06) * 2)) + ((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        `question_correct_by_level` `qcbl2`
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 5))),
                0) * 0.05) * 2)) + ((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        `question_correct_by_level` `qcbl2`
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 6))),
                0) * 0.04) * 2)) + ((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        `question_correct_by_level` `qcbl2`
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 7))),
                0) * 0.03) * 2)) + ((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        `question_correct_by_level` `qcbl2`
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 8))),
                0) * 0.02) * 2)) + ((COALESCE((SELECT 
                        `qcbl2`.`ratio_1st`
                    FROM
                        (`question_correct_by_level` `qcbl2`
                        JOIN `questions` `q`)
                    WHERE
                        ((`qcbl`.`question_id` = `qcbl2`.`question_id`)
                            AND (`qcbl2`.`member_level` = 9))),
                0) * 0.01) * 2))) AS `weight`
    FROM
        (`question_correct_by_level` `qcbl`
        JOIN `questions` `q`)
    WHERE
        (`qcbl`.`question_id` = `q`.`question_id`)
    GROUP BY `qcbl`.`question_id`