# Input:
# 2
# 1 -2 -1
# 5
# 0 1 -1 2 -2
# 3
# 2 1 -2 -1
# 4
# 0 -1 2 -2
# -1

# Output:
# Case 1:
# -1
# -2
# 2
# -1
# 7
# Case 2:
# -1
# 0
# 15
# -9


degree = gets.to_i
poly = []
(0..degree).each do
  poly << gets.to_i
end