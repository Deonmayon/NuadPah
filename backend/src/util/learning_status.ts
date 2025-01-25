export const getStatus = (
  learning_time: number, // time from user
  learning_round: number, // round from user
  timesup_condition: number, // expectation learning time  ( of Massaging )
  round_condition: number // expectation learning number of round  ( of Massaging )
) => {
  const statusConditions = {
    perfect:
      learning_time < timesup_condition && learning_round >= round_condition,
    justInTime: learning_time < timesup_condition,
    finish: learning_round >= round_condition,
  };

  const status = statusConditions.perfect
    ? "perfect"
    : statusConditions.justInTime
    ? "just in time"
    : statusConditions.finish
    ? "finish"
    : "not finish";
};
