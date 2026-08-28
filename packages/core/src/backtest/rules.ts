import { detectExitSignals, detectGoldenCross, QUALIFIED_STRENGTH } from '../signals/index.js';
import { computeLevels, computeScore } from '../scoring/index.js';
import type { DecisionContext, OpenPosition, Rule } from './engine.js';

/**
 * バックテストのルール。
 *
 * **日次パイプラインと同じ `detectGoldenCross` / `computeScore` を呼ぶ。**
 * ここで判定を書き直すと、検証したルールと本番で動くルールが別物になり、
 * バックテストが何も保証しなくなる。
 */

/** ゴールデンクロス（多段条件）で入り、手仕舞いシグナルか損切り / 利確で出る。 */
export const goldenCrossRule: Rule = {
  id: 'golden-cross-v1',
  shouldEnter(ctx: DecisionContext): boolean {
    const gc = detectGoldenCross(ctx.snapshot, ctx.prevSnapshot);
    return gc.qualified;
  },
  shouldExit(ctx: DecisionContext, _position: OpenPosition): boolean {
    return detectExitSignals(ctx.snapshot, ctx.prevSnapshot).triggered;
  },
  levels(ctx: DecisionContext) {
    const lv = computeLevels(ctx.snapshot);
    return { stop: lv.stop, target: lv.target };
  },
};

/** スコアが閾値以上になったら入る。配点そのものを検証したいとき用。 */
export function scoreThresholdRule(minTotal: number): Rule {
  return {
    id: `score-threshold-${minTotal}`,
    shouldEnter(ctx: DecisionContext): boolean {
      const result = computeScore(ctx.snapshot);
      return result.total !== null && result.total >= minTotal;
    },
    shouldExit(ctx: DecisionContext): boolean {
      return detectExitSignals(ctx.snapshot, ctx.prevSnapshot).triggered;
    },
    levels(ctx: DecisionContext) {
      const lv = computeLevels(ctx.snapshot);
      return { stop: lv.stop, target: lv.target };
    },
  };
}

export { QUALIFIED_STRENGTH };
