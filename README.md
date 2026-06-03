# Pig (Dice Game)

Pig is a simple, "jeopardy" style dice game. It is a game of risk management where players must decide when to bank their points and when to risk them for a higher score.

## How to Play

### Objective
The first player to reach **100 points** in their global score wins.

### Turn Mechanics
On each turn, a player rolls a single six-sided die.

1. **If the player rolls a 2 through 6:**
   - The value is added to their **Turn Total**.
   - The player can then choose to **Roll Again** or **Hold**.

2. **If the player chooses to Hold:**
   - Their current **Turn Total** is added to their **Global Score**.
   - Their turn ends, and the next player begins.

3. **If the player rolls a 1 (The "Pig"):**
   - The player loses their entire **Turn Total** for that turn.
   - Their turn ends immediately with no points added to their Global Score.

---

## Example Game Session

Here is how a typical sequence of turns might look between **Player 1** and **Player 2**:

| Turn | Action | Result | Turn Total | Player 1 Global | Player 2 Global | Notes |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **P1** | Roll | 4 | 4 | 0 | 0 | P1 starts with a 4. |
| **P1** | Roll | 6 | 10 | 0 | 0 | Risking it! Total is now 10. |
| **P1** | **Hold** | - | 0 | **10** | 0 | P1 banks 10 points. |
| **P2** | Roll | 5 | 5 | 10 | 0 | P2 starts. |
| **P2** | Roll | 1 | 0 | 10 | **0** | **PIG!** P2 loses the 5 points. |
| **P1** | Roll | 3 | 3 | 10 | 0 | P1 starts their second turn. |
| **P1** | **Hold** | - | 0 | **13** | 0 | P1 plays it safe. |

*The game continues until one player's Global Score reaches 100.*
