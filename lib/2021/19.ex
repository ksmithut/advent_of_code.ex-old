import AdventOfCode

advent_of_code 2021, 19 do
  @moduledoc """
  https://adventofcode.com/2021/day/19
  https://adventofcode.com/2021/day/19/input
  """
  def sample() do
    """
    --- scanner 0 ---
    404,-588,-901
    528,-643,409
    -838,591,734
    390,-675,-793
    -537,-823,-458
    -485,-357,347
    -345,-311,381
    -661,-816,-575
    -876,649,763
    -618,-824,-621
    553,345,-567
    474,580,667
    -447,-329,318
    -584,868,-557
    544,-627,-890
    564,392,-477
    455,729,728
    -892,524,684
    -689,845,-530
    423,-701,434
    7,-33,-71
    630,319,-379
    443,580,662
    -789,900,-551
    459,-707,401

    --- scanner 1 ---
    686,422,578
    605,423,415
    515,917,-361
    -336,658,858
    95,138,22
    -476,619,847
    -340,-569,-846
    567,-361,727
    -460,603,-452
    669,-402,600
    729,430,532
    -500,-761,534
    -322,571,750
    -466,-666,-811
    -429,-592,574
    -355,545,-477
    703,-491,-529
    -328,-685,520
    413,935,-424
    -391,539,-444
    586,-435,557
    -364,-763,-893
    807,-499,-711
    755,-354,-619
    553,889,-390

    --- scanner 2 ---
    649,640,665
    682,-795,504
    -784,533,-524
    -644,584,-595
    -588,-843,648
    -30,6,44
    -674,560,763
    500,723,-460
    609,671,-379
    -555,-800,653
    -675,-892,-343
    697,-426,-610
    578,704,681
    493,664,-388
    -671,-858,530
    -667,343,800
    571,-461,-707
    -138,-166,112
    -889,563,-600
    646,-828,498
    640,759,510
    -630,509,768
    -681,-892,-333
    673,-379,-804
    -742,-814,-386
    577,-820,562

    --- scanner 3 ---
    -589,542,597
    605,-692,669
    -500,565,-823
    -660,373,557
    -458,-679,-417
    -488,449,543
    -626,468,-788
    338,-750,-386
    528,-832,-391
    562,-778,733
    -938,-730,414
    543,643,-506
    -524,371,-870
    407,773,750
    -104,29,83
    378,-903,-323
    -778,-728,485
    426,699,580
    -438,-605,-362
    -469,-447,-387
    509,732,623
    647,635,-688
    -868,-804,481
    614,-800,639
    595,780,-596

    --- scanner 4 ---
    727,592,562
    -293,-554,779
    441,611,-461
    -714,465,-776
    -743,427,-804
    -660,-479,-426
    832,-632,460
    927,-485,-438
    408,393,-506
    466,436,-512
    110,16,151
    -258,-428,682
    -393,719,612
    -211,-452,876
    808,-476,-593
    -575,615,604
    -485,667,467
    -680,325,-822
    -627,-443,-432
    872,-547,-609
    833,512,582
    807,604,487
    839,-516,451
    891,-625,532
    -652,-548,-490
    30,-46,-14
    """
  end

  defp parse_input(input) do
    input
    |> String.trim()
    |> String.split("\n\n")
    |> Enum.map(&parse_scanner/1)
  end

  defp parse_scanner(scanner_string) do
    scanner_string
    |> String.split("\n", trim: true)
    |> tl()
    |> Enum.map(&String.split(&1, ","))
    |> Enum.map(&parse_line/1)
  end

  defp parse_line(line), do: line |> Enum.map(&String.to_integer/1) |> List.to_tuple()

  @doc """
  ## Examples
      iex> sample() |> part_1()
      79

      iex> input() |> part_1()
      350
  """
  def part_1(input) do
    [scanner | scanners] = parse_input(input)

    align_scanners(scanners, [scanner], [])
    |> List.flatten()
    |> MapSet.new()
    |> MapSet.size()
  end

  defp align_scanners([], aligned, done), do: Enum.concat(done, aligned)

  defp align_scanners(rest, [next | tail], done) do
    {new, rest, _} = align_next(next, rest, [], [], [])
    align_scanners(rest, Enum.concat(new, tail), [next | done])
  end

  defp rotations(),
    do: [
      {-1, -2, 3},
      {-1, -3, -2},
      {-1, 2, -3},
      {-1, 3, 2},
      {-2, -1, -3},
      {-2, -3, 1},
      {-2, 1, 3},
      {-2, 3, -1},
      {-3, -1, 2},
      {-3, -2, -1},
      {-3, 1, -2},
      {-3, 2, 1},
      {1, -2, -3},
      {1, -3, 2},
      {1, 2, 3},
      {1, 3, -2},
      {2, -1, 3},
      {2, -3, -1},
      {2, 1, -3},
      {2, 3, 1},
      {3, -1, -2},
      {3, -2, 1},
      {3, 1, 2},
      {3, 2, -1}
    ]

  defp shift({x1, y1, z1}, {x2, y2, z2}), do: {x2 - x1, y2 - y1, z2 - z1}
  defp shiftv(l, d), do: Enum.map(l, &shift(d, &1))

  defp align_xyz(l, r) do
    for(a <- l, b <- r, do: shift(a, b))
    |> Enum.frequencies()
    |> Enum.max_by(&elem(&1, 1))
    |> case do
      {best, freq} when freq >= 12 -> best
      _ -> nil
    end
  end

  defp pick(l, rot), do: elem(l, abs(rot) - 1) * div(rot, abs(rot))
  defp rotate([], _), do: []

  defp rotate([h | t], r = {r0, r1, r2}),
    do: [{pick(h, r0), pick(h, r1), pick(h, r2)} | rotate(t, r)]

  defp align_rotation(l, r),
    do: for(rot <- rotations(), into: %{}, do: {rot, align_xyz(l, rotate(r, rot))})

  defp align_next(_, [], good, bad, pos), do: {good, bad, pos}

  defp align_next(next, [h | t], good, bad, pos) do
    align_rotation(next, h)
    |> Enum.find(&(not is_nil(elem(&1, 1))))
    |> case do
      {rot, diff} -> align_next(next, t, [shiftv(rotate(h, rot), diff) | good], bad, [diff | pos])
      nil -> align_next(next, t, good, [h | bad], pos)
    end
  end

  @doc """
  ## Examples
      iex> sample() |> part_2()
      3621

      # iex> input() |> part_2()
      # input()
  """
  def part_2(input) do
    [scanner | scanners] = input |> parse_input()

    get_scanners([{0, 0, 0}], [scanner], scanners)
    |> combos()
    |> Enum.map(fn {a, b} -> delta(a, b) end)
    |> Enum.max()
  end

  defp combos(list), do: for(a <- list, b <- list, a != b, do: {a, b})

  def get_scanners(pos, _, []), do: pos

  def get_scanners(pos, [next | t], rest) do
    {new, rest, npos} = align_next(next, rest, [], [], [])
    get_scanners(Enum.concat(pos, npos), Enum.concat(new, t), rest)
  end

  defp delta({x1, y1, z1}, {x2, y2, z2}), do: abs(x2 - x1) + abs(y2 - y1) + abs(z2 - z1)
end
