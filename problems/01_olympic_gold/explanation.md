# Explanation — Olympic Gold Medals (Problem 01)

## Problem overview

The goal of this problem is to determine **how many gold medals each swimmer has won**, but **only for swimmers who have won exclusively gold medals**.

From a business perspective, this translates to:
- Identifying athletes who **never placed second or third**
- Quantifying their dominance by counting how many times they won gold

From a technical perspective:
- Medal types are stored as **separate columns** (`GOLD`, `SILVER`, `BRONZE`)
- A swimmer’s name can appear in **different columns across different rows**
- We must exclude any swimmer who appears **even once** in `SILVER` or `BRONZE`

---

## Data understanding & modeling

### Table: `dbo.events`

Each row represents an event result with three medalists:

| Column  | Meaning |
|-------|--------|
| `GOLD` | Gold medal winner |
| `SILVER` | Silver medal winner |
| `BRONZE` | Bronze medal winner |

Important modeling observation:
- Medal types are modeled as **columns, not rows**
- This requires **cross-column validation** to enforce the “gold-only” rule

---

## Final solution (primary)

```sql
SELECT
  e.GOLD AS player_name,
  COUNT(*) AS gold_medal_count
FROM dbo.events AS e
WHERE e.GOLD IS NOT NULL
  AND NOT EXISTS (
    SELECT 1
    FROM dbo.events AS x
    WHERE x.SILVER = e.GOLD
       OR x.BRONZE = e.GOLD
  )
GROUP BY e.GOLD
ORDER BY gold_medal_count DESC, player_name;
