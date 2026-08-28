export {
  runBacktest,
  assertExecutionBar,
  type BacktestOptions,
  type BacktestResult,
  type DecisionContext,
  type EquityPoint,
  type ExitReason,
  type History,
  type OpenPosition,
  type Rule,
  type Trade,
} from './engine.js';
export { summarise, maxDrawdown, sharpe, totalReturn, TRADING_DAYS_PER_YEAR, type BacktestStats } from './stats.js';
export { goldenCrossRule, scoreThresholdRule } from './rules.js';
