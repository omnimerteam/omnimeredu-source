// utils/conditionEvaluator.ts
function getByPath(obj: any, path: string) {
  if (!path) return undefined;
  return path.split(".").reduce((o: any, p) => (o ? o[p] : undefined), obj);
}

export function evalCondition(
  cond: { field: string; operator: string; value: any },
  context: any
): boolean {
  const left = getByPath(context, cond.field);
  const right = cond.value;
  switch (cond.operator) {
    case "eq":
      return left === right;
    case "neq":
      return left !== right;
    case "gt":
      return left > right;
    case "gte":
      return left >= right;
    case "lt":
      return left < right;
    case "lte":
      return left <= right;
    case "in":
      if (Array.isArray(right)) return right.includes(left);
      if (Array.isArray(left)) return left.includes(right);
      return false;
    case "nin":
      if (Array.isArray(right)) return !right.includes(left);
      if (Array.isArray(left)) return !left.includes(right);
      return true;
    default:
      return false;
  }
}

export function conditionsMatch(conds: any[] = [], context: any) {
  if (!conds || conds.length === 0) return true;
  return conds.every((c) => evalCondition(c, context));
}
