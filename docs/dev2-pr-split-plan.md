# dev2 PR Split Plan (8 PRs x 10 commits)

This plan splits the `dev`-only commits into 8 sequential PRs for a new `dev2` flow.

## Base setup

```bash
git checkout main
git pull
git checkout -b dev2
git push -u origin dev2
```

After each PR merges into `dev2`, create the next PR branch from updated `dev2`.

---

## PR 1 (commits 1-10)

Branch: `dev2-pr-01`

```bash
git checkout dev2
git pull
git checkout -b dev2-pr-01
git cherry-pick e7bcb5e 80a224a b3a935c 0120daf 88b59fe f777cb2 152923b 3041a45 9f1344f b5c8337
git push -u origin dev2-pr-01
```

---

## PR 2 (commits 11-20)

Branch: `dev2-pr-02`

```bash
git checkout dev2
git pull
git checkout -b dev2-pr-02
git cherry-pick e1927f2 4fc3894 33d0234 4272922 639c775 3b5fd29 4e90533 d56b3d5 133467d c283ff0
git push -u origin dev2-pr-02
```

---

## PR 3 (commits 21-30)

Branch: `dev2-pr-03`

```bash
git checkout dev2
git pull
git checkout -b dev2-pr-03
git cherry-pick 8c8e5ff d5f3628 0b648b1 a6791b6 b22f81d 1a0ca7d e6b11fb 2067c09 8837212 d943487
git push -u origin dev2-pr-03
```

---

## PR 4 (commits 31-40)

Branch: `dev2-pr-04`

```bash
git checkout dev2
git pull
git checkout -b dev2-pr-04
git cherry-pick 8c9de2e d3b2ca8 c33e563 a4fbaf5 308c2e1 ac25aaf c819b5f 77de805 c99ffe8 f725e05
git push -u origin dev2-pr-04
```

---

## PR 5 (commits 41-50)

Branch: `dev2-pr-05`

```bash
git checkout dev2
git pull
git checkout -b dev2-pr-05
git cherry-pick 1ee3f72 e26c63b a27336c 0e95af3 aa1dca1 c172a7e 989d05e e29f197 31d6319 2939f1b
git push -u origin dev2-pr-05
```

---

## PR 6 (commits 51-60)

Branch: `dev2-pr-06`

```bash
git checkout dev2
git pull
git checkout -b dev2-pr-06
git cherry-pick 22f8820 6d9570a 8824042 ed2b372 ee3f465 3472036 3410b35 341bdef d9c1fd6 5769170
git push -u origin dev2-pr-06
```

---

## PR 7 (commits 61-70)

Branch: `dev2-pr-07`

```bash
git checkout dev2
git pull
git checkout -b dev2-pr-07
git cherry-pick f415ea2 bd33046 86cac4e f9ec8ee 737662b 553d885 73724a8 cb8120d 913bc68 0da0c89
git push -u origin dev2-pr-07
```

---

## PR 8 (commits 71-80)

Branch: `dev2-pr-08`

```bash
git checkout dev2
git pull
git checkout -b dev2-pr-08
git cherry-pick cc9f34d d9adcfd 5823329 0a2f0ad 27f6532 cf20c54 b99a1c8 caae7f8 5071ec5
git cherry-pick -m 1 f489992
git push -u origin dev2-pr-08
```

Note: `f489992` is a merge commit, so `-m 1` is required.

---

## Ordered commit reference (all 80)

1. e7bcb5e
2. 80a224a
3. b3a935c
4. 0120daf
5. 88b59fe
6. f777cb2
7. 152923b
8. 3041a45
9. 9f1344f
10. b5c8337
11. e1927f2
12. 4fc3894
13. 33d0234
14. 4272922
15. 639c775
16. 3b5fd29
17. 4e90533
18. d56b3d5
19. 133467d
20. c283ff0
21. 8c8e5ff
22. d5f3628
23. 0b648b1
24. a6791b6
25. b22f81d
26. 1a0ca7d
27. e6b11fb
28. 2067c09
29. 8837212
30. d943487
31. 8c9de2e
32. d3b2ca8
33. c33e563
34. a4fbaf5
35. 308c2e1
36. ac25aaf
37. c819b5f
38. 77de805
39. c99ffe8
40. f725e05
41. 1ee3f72
42. e26c63b
43. a27336c
44. 0e95af3
45. aa1dca1
46. c172a7e
47. 989d05e
48. e29f197
49. 31d6319
50. 2939f1b
51. 22f8820
52. 6d9570a
53. 8824042
54. ed2b372
55. ee3f465
56. 3472036
57. 3410b35
58. 341bdef
59. d9c1fd6
60. 5769170
61. f415ea2
62. bd33046
63. 86cac4e
64. f9ec8ee
65. 737662b
66. 553d885
67. 73724a8
68. cb8120d
69. 913bc68
70. 0da0c89
71. cc9f34d
72. d9adcfd
73. 5823329
74. 0a2f0ad
75. 27f6532
76. cf20c54
77. b99a1c8
78. caae7f8
79. 5071ec5
80. f489992
