defmodule ExAliyunOtsTest.PlainBuffer do
  use ExUnit.Case
  require Logger
  alias ExAliyunOts.Const.PKType
  require PKType
  alias ExAliyunOts.PlainBuffer, as: PlainBuffer

  test "deserialize row with primary keys only" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 41, 0, 0, 0, 3, 36, 0, 0, 0, 99, 51, 98, 101, 56, 54, 49, 55, 45, 49, 48,
        100, 55, 45, 52, 50, 50, 98, 45, 56, 102, 56, 48, 45, 53, 56, 54, 48, 51, 100, 49, 54, 48,
        51, 100, 54, 10, 77, 3, 4, 10, 0, 0, 0, 100, 101, 102, 97, 117, 108, 116, 95, 105, 100, 5,
        9, 0, 0, 0, 0, 168, 208, 145, 104, 49, 91, 5, 0, 10, 195, 3, 4, 8, 0, 0, 0, 111, 114, 100,
        101, 114, 95, 105, 100, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 111, 114, 100, 101, 114, 50, 10,
        221, 9, 6>>

    {primary_keys, nil} = PlainBuffer.deserialize_row(row)
    assert length(primary_keys) == 3
    assert {"partition_key", "c3be8617-10d7-422b-8f80-58603d1603d6"} = Enum.at(primary_keys, 0)
    assert {"default_id", 1_507_642_649_465_000} = Enum.at(primary_keys, 1)
    assert {"order_id", "order2"} = Enum.at(primary_keys, 2)
  end

  test "deserialize row with primary keys and columns" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 41, 0, 0, 0, 3, 36, 0, 0, 0, 99, 51, 98, 101, 56, 54, 49, 55, 45, 49, 48,
        100, 55, 45, 52, 50, 50, 98, 45, 56, 102, 56, 48, 45, 53, 56, 54, 48, 51, 100, 49, 54, 48,
        51, 100, 54, 10, 77, 3, 4, 10, 0, 0, 0, 100, 101, 102, 97, 117, 108, 116, 95, 105, 100, 5,
        9, 0, 0, 0, 0, 0, 41, 115, 104, 49, 91, 5, 0, 10, 241, 3, 4, 8, 0, 0, 0, 111, 114, 100,
        101, 114, 95, 105, 100, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 111, 114, 100, 101, 114, 50, 10,
        221, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 20, 0, 0, 0, 3, 15, 0, 0, 0, 117, 112,
        100, 97, 116, 101, 100, 95, 110, 97, 109, 101, 95, 118, 50, 7, 189, 35, 129, 6, 95, 1, 0,
        0, 10, 151, 9, 29>>

    {primary_keys, attributes} = PlainBuffer.deserialize_row(row)
    assert length(primary_keys) == 3
    assert length(attributes) == 1
    assert {"partition_key", "c3be8617-10d7-422b-8f80-58603d1603d6"} = Enum.at(primary_keys, 0)
    assert {"default_id", 1_507_642_647_456_000} = Enum.at(primary_keys, 1)
    assert {"order_id", "order2"} = Enum.at(primary_keys, 2)
    assert {"name", "updated_name_v2", 1_507_642_647_485} = Enum.at(attributes, 0)
  end

  test "deserialize case to fix lose attributes" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 41, 0, 0, 0, 3, 36, 0, 0, 0, 99, 51, 98, 101, 56, 54, 49, 55, 45, 49, 48,
        100, 55, 45, 52, 50, 50, 98, 45, 56, 102, 56, 48, 45, 53, 56, 54, 48, 51, 100, 49, 54, 48,
        51, 100, 54, 10, 77, 3, 4, 10, 0, 0, 0, 100, 101, 102, 97, 117, 108, 116, 95, 105, 100, 5,
        9, 0, 0, 0, 0, 224, 108, 205, 137, 60, 91, 5, 0, 10, 68, 3, 4, 8, 0, 0, 0, 111, 114, 100,
        101, 114, 95, 105, 100, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 111, 114, 100, 101, 114, 50, 10,
        221, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 20, 0, 0, 0, 3, 15, 0, 0, 0, 117, 112,
        100, 97, 116, 101, 100, 95, 110, 97, 109, 101, 95, 118, 50, 7, 231, 146, 90, 9, 95, 1, 0,
        0, 10, 229, 9, 67>>

    {primary_keys, attributes} = PlainBuffer.deserialize_row(row)
    assert length(primary_keys) == 3
    assert length(attributes) == 1
    assert {"partition_key", "c3be8617-10d7-422b-8f80-58603d1603d6"} = Enum.at(primary_keys, 0)
    assert {"default_id", 1_507_690_451_660_000} = Enum.at(primary_keys, 1)
    assert {"order_id", "order2"} = Enum.at(primary_keys, 2)
    assert {"name", "updated_name_v2", 1_507_690_451_687} = Enum.at(attributes, 0)
  end

  test "serialize primary keys for get_range" do
    # the test sample data `sample_data_inf_min` is calculated by Python SDK, the corresponding input parimary keys are [("gid", 1), ("uid", INF_MIN)]
    sample_data_inf_min =
      <<117, 0, 0, 0, 1, 3, 4, 3, 0, 0, 0, 103, 105, 100, 5, 9, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0,
        0, 10, 42, 3, 4, 3, 0, 0, 0, 117, 105, 100, 5, 1, 0, 0, 0, 9, 10, 29, 9, 122>>

    serialized_pk_with_inf_min =
      PlainBuffer.serialize_primary_keys([{"gid", 1}, {"uid", PKType.inf_min()}])

    assert sample_data_inf_min == serialized_pk_with_inf_min

    # the test sample data `sample_data_inf_max` is calculated by Python SDK, the corresponding input parimary keys are [("gid", 4), ("uid", INF_MAX)]
    sample_data_inf_max =
      <<117, 0, 0, 0, 1, 3, 4, 3, 0, 0, 0, 103, 105, 100, 5, 9, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0,
        0, 10, 117, 3, 4, 3, 0, 0, 0, 117, 105, 100, 5, 1, 0, 0, 0, 10, 10, 20, 9, 164>>

    serialized_pk_with_inf_max =
      PlainBuffer.serialize_primary_keys([{"gid", 4}, {"uid", PKType.inf_max()}])

    assert sample_data_inf_max == serialized_pk_with_inf_max
  end

  test "deserialize rows from get_range result" do
    rows =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 10, 57, 3, 4, 2, 0, 0, 0, 105, 100, 5,
        9, 0, 0, 0, 0, 168, 110, 133, 227, 86, 91, 5, 0, 10, 111, 2, 3, 4, 4, 0, 0, 0, 110, 97,
        109, 101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 110, 97, 109, 101, 95, 49, 7, 57, 122, 25, 16,
        95, 1, 0, 0, 10, 194, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 1, 0, 0,
        0, 0, 0, 0, 0, 7, 57, 122, 25, 16, 95, 1, 0, 0, 10, 177, 9, 171, 1, 3, 4, 13, 0, 0, 0,
        112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107, 101, 121, 5, 9, 0, 0, 0, 0, 2, 0, 0,
        0, 0, 0, 0, 0, 10, 12, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 112, 30, 134, 227,
        86, 91, 5, 0, 10, 239, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 11, 0, 0, 0, 3, 6, 0, 0,
        0, 110, 97, 109, 101, 95, 50, 7, 102, 122, 25, 16, 95, 1, 0, 0, 10, 67, 3, 4, 5, 0, 0, 0,
        118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 102, 122, 25, 16, 95,
        1, 0, 0, 10, 189, 9, 189, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111,
        110, 95, 107, 101, 121, 5, 9, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 10, 31, 3, 4, 2, 0, 0,
        0, 105, 100, 5, 9, 0, 0, 0, 0, 240, 92, 134, 227, 86, 91, 5, 0, 10, 172, 2, 3, 4, 4, 0, 0,
        0, 110, 97, 109, 101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 110, 97, 109, 101, 95, 51, 7, 118,
        122, 25, 16, 95, 1, 0, 0, 10, 13, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0,
        0, 3, 0, 0, 0, 0, 0, 0, 0, 7, 118, 122, 25, 16, 95, 1, 0, 0, 10, 136, 9, 154, 1, 3, 4, 13,
        0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107, 101, 121, 5, 9, 0, 0, 0, 0,
        4, 0, 0, 0, 0, 0, 0, 0, 10, 102, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 184, 143,
        134, 227, 86, 91, 5, 0, 10, 146, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 11, 0, 0, 0,
        3, 6, 0, 0, 0, 110, 97, 109, 101, 95, 52, 7, 131, 122, 25, 16, 95, 1, 0, 0, 10, 0, 3, 4,
        5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 7, 131, 122,
        25, 16, 95, 1, 0, 0, 10, 227, 9, 225, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116,
        105, 111, 110, 95, 107, 101, 121, 5, 9, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 10, 117, 3, 4,
        2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 192, 225, 134, 227, 86, 91, 5, 0, 10, 77, 2, 3, 4,
        4, 0, 0, 0, 110, 97, 109, 101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 110, 97, 109, 101, 95, 53,
        7, 152, 122, 25, 16, 95, 1, 0, 0, 10, 227, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9,
        0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 7, 152, 122, 25, 16, 95, 1, 0, 0, 10, 123, 9, 80, 1,
        3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107, 101, 121, 5, 9, 0,
        0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 10, 64, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0,
        136, 20, 135, 227, 86, 91, 5, 0, 10, 55, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 11, 0,
        0, 0, 3, 6, 0, 0, 0, 110, 97, 109, 101, 95, 54, 7, 165, 122, 25, 16, 95, 1, 0, 0, 10, 246,
        3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 6, 0, 0, 0, 0, 0, 0, 0, 7,
        165, 122, 25, 16, 95, 1, 0, 0, 10, 227, 9, 110, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116,
        105, 116, 105, 111, 110, 95, 107, 101, 121, 5, 9, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 10,
        83, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 192, 94, 135, 227, 86, 91, 5, 0, 10,
        101, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 110, 97, 109,
        101, 95, 55, 7, 184, 122, 25, 16, 95, 1, 0, 0, 10, 127, 3, 4, 5, 0, 0, 0, 118, 97, 108,
        117, 101, 5, 9, 0, 0, 0, 0, 7, 0, 0, 0, 0, 0, 0, 0, 7, 184, 122, 25, 16, 95, 1, 0, 0, 10,
        17, 9, 37, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107, 101,
        121, 5, 9, 0, 0, 0, 0, 8, 0, 0, 0, 0, 0, 0, 0, 10, 178, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9,
        0, 0, 0, 0, 112, 149, 135, 227, 86, 91, 5, 0, 10, 192, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109,
        101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 110, 97, 109, 101, 95, 56, 7, 198, 122, 25, 16, 95, 1,
        0, 0, 10, 161, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 8, 0, 0, 0, 0,
        0, 0, 0, 7, 198, 122, 25, 16, 95, 1, 0, 0, 10, 120, 9, 134, 1, 3, 4, 13, 0, 0, 0, 112, 97,
        114, 116, 105, 116, 105, 111, 110, 95, 107, 101, 121, 5, 9, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0,
        0, 0, 10, 161, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 120, 231, 135, 227, 86, 91,
        5, 0, 10, 214, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 110,
        97, 109, 101, 95, 57, 7, 219, 122, 25, 16, 95, 1, 0, 0, 10, 40, 3, 4, 5, 0, 0, 0, 118, 97,
        108, 117, 101, 5, 9, 0, 0, 0, 0, 9, 0, 0, 0, 0, 0, 0, 0, 7, 219, 122, 25, 16, 95, 1, 0, 0,
        10, 138, 9, 14, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 10, 0, 0, 0, 0, 0, 0, 0, 10, 148, 3, 4, 2, 0, 0, 0, 105, 100,
        5, 9, 0, 0, 0, 0, 40, 30, 136, 227, 86, 91, 5, 0, 10, 37, 2, 3, 4, 4, 0, 0, 0, 110, 97,
        109, 101, 5, 12, 0, 0, 0, 3, 7, 0, 0, 0, 110, 97, 109, 101, 95, 49, 48, 7, 233, 122, 25,
        16, 95, 1, 0, 0, 10, 220, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 10,
        0, 0, 0, 0, 0, 0, 0, 7, 233, 122, 25, 16, 95, 1, 0, 0, 10, 243, 9, 84>>

    rows_data = PlainBuffer.deserialize_rows(rows)

    assert length(rows_data) == 10

    rows_data
    |> Enum.with_index()
    |> Enum.map(fn {{primary_keys, attribute_columns}, index} ->
      value = index + 1
      assert {"partition_key", ^value} = Enum.at(primary_keys, 0)
      name_value = "name_#{value}"
      assert {"name", ^name_value, _timestamp} = Enum.at(attribute_columns, 0)
      assert {"value", ^value, _timestamp} = Enum.at(attribute_columns, 1)
    end)
  end

  test "deserialize put row" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 2, 3, 0, 0, 0, 0, 0, 0, 10, 106, 3, 4, 2, 0, 0, 0, 105, 100,
        5, 9, 0, 0, 0, 0, 184, 182, 184, 239, 105, 91, 5, 0, 10, 36, 9, 184>>

    {primary_keys, attribute_columns} = PlainBuffer.deserialize_row(row)
    assert attribute_columns == nil
    assert length(primary_keys) == 2
    assert {"partition_key", 770} = Enum.at(primary_keys, 0)
    assert {"id", 1_507_885_435_107_000} = Enum.at(primary_keys, 1)
  end

  test "deserialize put row 2" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 3, 4, 0, 0, 0, 0, 0, 0, 10, 106, 3, 4, 2, 0, 0, 0, 105, 100,
        5, 9, 0, 0, 0, 0, 152, 236, 34, 46, 106, 91, 5, 0, 10, 231, 9, 106>>

    result = PlainBuffer.deserialize_row(row)
    Logger.debug(fn -> "#{inspect(result)}" end)
  end

  test "deserialize rows" do
    rows =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 10, 57, 3, 4, 2, 0, 0, 0, 105, 100, 5,
        9, 0, 0, 0, 0, 240, 98, 69, 111, 121, 91, 5, 0, 10, 4, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109,
        101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 110, 97, 109, 101, 95, 49, 7, 54, 122, 241, 24, 95, 1,
        0, 0, 10, 212, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 1, 0, 0, 0, 0,
        0, 0, 0, 7, 54, 122, 241, 24, 95, 1, 0, 0, 10, 167, 9, 130, 1, 3, 4, 13, 0, 0, 0, 112, 97,
        114, 116, 105, 116, 105, 111, 110, 95, 107, 101, 121, 5, 9, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0,
        0, 0, 10, 12, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 208, 8, 71, 111, 121, 91, 5,
        0, 10, 143, 2, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 110,
        97, 109, 101, 95, 50, 7, 162, 122, 241, 24, 95, 1, 0, 0, 10, 155, 3, 4, 5, 0, 0, 0, 118,
        97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 162, 122, 241, 24, 95, 1,
        0, 0, 10, 101, 9, 132>>

    result = PlainBuffer.deserialize_rows(rows)

    assert [
             {[{"partition_key", 1}, {"id", 1_507_951_999_542_000}],
              [{"name", "name_1", 1_507_951_999_542}, {"value", 1, 1_507_951_999_542}]},
             {[{"partition_key", 2}, {"id", 1_507_951_999_650_000}],
              [{"name", "name_2", 1_507_951_999_650}, {"value", 2, 1_507_951_999_650}]}
           ] = result
  end

  test "deserialize rows 2" do
    rows =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 164, 19, 0, 0, 0, 0, 0, 0, 10, 2, 3, 4, 2, 0, 0, 0, 105, 100,
        5, 9, 0, 0, 0, 0, 48, 196, 224, 125, 121, 91, 5, 0, 10, 44, 2, 3, 4, 4, 0, 0, 0, 110, 97,
        109, 101, 5, 14, 0, 0, 0, 3, 9, 0, 0, 0, 110, 97, 109, 101, 95, 53, 48, 50, 56, 7, 126,
        55, 245, 24, 95, 1, 0, 0, 10, 111, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0,
        0, 0, 164, 19, 0, 0, 0, 0, 0, 0, 7, 126, 55, 245, 24, 95, 1, 0, 0, 10, 182, 9, 81>>

    result = PlainBuffer.deserialize_rows(rows)

    assert [
             {[{"partition_key", 5028}, {"id", 1_507_952_244_606_000}],
              [{"name", "name_5028", 1_507_952_244_606}, {"value", 5028, 1_507_952_244_606}]}
           ] == result

    rows =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 18, 0, 0, 0, 0, 0, 0, 0, 10, 59, 3, 4, 2, 0, 0, 0, 105, 100,
        5, 9, 0, 0, 0, 0, 192, 22, 83, 111, 121, 91, 5, 0, 10, 119, 2, 3, 4, 4, 0, 0, 0, 110, 97,
        109, 101, 5, 12, 0, 0, 0, 3, 7, 0, 0, 0, 110, 97, 109, 101, 95, 49, 56, 7, 184, 125, 241,
        24, 95, 1, 0, 0, 10, 1, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0, 18, 0,
        0, 0, 0, 0, 0, 0, 7, 184, 125, 241, 24, 95, 1, 0, 0, 10, 223, 9, 171>>

    result = PlainBuffer.deserialize_rows(rows)

    assert [
             {[{"partition_key", 18}, {"id", 1_507_952_000_440_000}],
              [{"name", "name_18", 1_507_952_000_440}, {"value", 18, 1_507_952_000_440}]}
           ] == result

    rows =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 88, 2, 0, 0, 0, 0, 0, 0, 10, 224, 3, 4, 2, 0, 0, 0, 105, 100,
        5, 9, 0, 0, 0, 0, 160, 13, 253, 112, 121, 91, 5, 0, 10, 246, 2, 3, 4, 4, 0, 0, 0, 110, 97,
        109, 101, 5, 13, 0, 0, 0, 3, 8, 0, 0, 0, 110, 97, 109, 101, 95, 54, 48, 48, 7, 196, 234,
        241, 24, 95, 1, 0, 0, 10, 2, 3, 4, 5, 0, 0, 0, 118, 97, 108, 117, 101, 5, 9, 0, 0, 0, 0,
        88, 2, 0, 0, 0, 0, 0, 0, 7, 196, 234, 241, 24, 95, 1, 0, 0, 10, 61, 9, 138>>

    result = PlainBuffer.deserialize_rows(rows)

    assert [
             {[{"partition_key", 600}, {"id", 1_507_952_028_356_000}],
              [{"name", "name_600", 1_507_952_028_356}, {"value", 600, 1_507_952_028_356}]}
           ] == result

    rows =
      <<117, 0, 0, 0, 1, 3, 4, 8, 0, 0, 0, 117, 110, 105, 120, 116, 105, 109, 101, 5, 9, 0, 0, 0,
        0, 113, 184, 83, 92, 0, 0, 0, 0, 10, 2, 3, 4, 7, 0, 0, 0, 117, 115, 101, 114, 95, 105,
        100, 5, 23, 0, 0, 0, 3, 18, 0, 0, 0, 51, 48, 56, 56, 56, 48, 50, 52, 54, 56, 54, 54, 53,
        52, 54, 52, 49, 48, 10, 255, 2, 3, 4, 8, 0, 0, 0, 98, 105, 114, 116, 104, 100, 97, 121, 5,
        15, 0, 0, 0, 3, 10, 0, 0, 0, 49, 57, 57, 52, 45, 48, 51, 45, 48, 50, 7, 49, 123, 8, 167,
        104, 1, 0, 0, 10, 2, 3, 4, 11, 0, 0, 0, 98, 105, 122, 95, 99, 97, 114, 100, 95, 110, 111,
        5, 22, 0, 0, 0, 3, 17, 0, 0, 0, 49, 50, 51, 48, 48, 50, 48, 48, 48, 50, 48, 56, 55, 56,
        56, 54, 49, 7, 49, 123, 8, 167, 104, 1, 0, 0, 10, 138, 9, 247>>

    result = PlainBuffer.deserialize_rows(rows)

    assert [
             {[{"unixtime", 1_548_990_577}, {"user_id", "308880246866546410"}],
              [
                {"birthday", "1994-03-02", 1_548_990_577_457},
                {"biz_card_no", "12300200020878861", 1_548_990_577_457}
              ]}
           ] == result
  end

  test "serialize put row with float value" do
    pks = [{"partition_key", 1}]
    attrs = [{"size", 1.1}]
    result = PlainBuffer.serialize_for_put_row(pks, attrs)

    expected =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 10, 57, 2, 3, 4, 4, 0, 0, 0, 115, 105,
        122, 101, 5, 9, 0, 0, 0, 1, 154, 153, 153, 153, 153, 153, 241, 63, 10, 95, 9, 20>>

    assert result == expected
  end

  test "serialize delete row" do
    pks = [{"partition_key", 1}]
    result = PlainBuffer.serialize_for_delete_row(pks)

    expected =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 10, 57, 8, 9, 67>>

    assert result == expected
  end

  test "serialize put row with non-ascii" do
    pks = [{"partition_key", 3}]
    attrs = [{"name", "测试"}]
    result = PlainBuffer.serialize_for_put_row(pks, attrs)

    expected =
      <<117, 0, 0, 0, 1, 3, 4, 13, 0, 0, 0, 112, 97, 114, 116, 105, 116, 105, 111, 110, 95, 107,
        101, 121, 5, 9, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0, 0, 0, 10, 31, 2, 3, 4, 4, 0, 0, 0, 110, 97,
        109, 101, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 230, 181, 139, 232, 175, 149, 10, 98, 9, 58>>

    assert result == expected
    row = PlainBuffer.deserialize_row(result)
    assert row == {[{"partition_key", 3}], [{"name", "测试", nil}]}
  end

  test "splice rows may make some item missed" do
    rows =
      <<117, 0, 0, 0, 1, 3, 4, 9, 0, 0, 0, 116, 105, 109, 101, 115, 116, 97, 109, 112, 5, 9, 0, 0,
        0, 0, 28, 146, 229, 90, 0, 0, 0, 0, 10, 243, 3, 4, 15, 0, 0, 0, 99, 111, 110, 102, 105,
        114, 109, 97, 116, 105, 111, 110, 95, 105, 100, 5, 12, 0, 0, 0, 3, 7, 0, 0, 0, 72, 86, 55,
        56, 50, 51, 52, 10, 232, 2, 3, 4, 16, 0, 0, 0, 110, 117, 109, 98, 101, 114, 95, 111, 102,
        95, 103, 117, 101, 115, 116, 115, 5, 9, 0, 0, 0, 0, 4, 0, 0, 0, 0, 0, 0, 0, 7, 40, 194,
        194, 16, 99, 1, 0, 0, 10, 1, 3, 4, 15, 0, 0, 0, 110, 117, 109, 98, 101, 114, 95, 111, 102,
        95, 114, 111, 111, 109, 115, 5, 9, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 7, 40, 194, 194,
        16, 99, 1, 0, 0, 10, 218, 3, 4, 10, 0, 0, 0, 115, 116, 97, 114, 116, 95, 100, 97, 116,
        101, 5, 15, 0, 0, 0, 3, 10, 0, 0, 0, 50, 48, 49, 56, 45, 48, 53, 45, 48, 57, 7, 40, 194,
        194, 16, 99, 1, 0, 0, 10, 1, 3, 4, 9, 0, 0, 0, 115, 117, 98, 109, 105, 116, 95, 105, 112,
        5, 20, 0, 0, 0, 3, 15, 0, 0, 0, 49, 49, 54, 46, 50, 48, 55, 46, 50, 50, 55, 46, 49, 49,
        55, 7, 40, 194, 194, 16, 99, 1, 0, 0, 10, 124, 9, 51>>

    readabled_rows = PlainBuffer.deserialize_rows(rows)

    for row <- readabled_rows do
      {pks, attrs} = row
      assert pks == [{"timestamp", 1_524_994_588}, {"confirmation_id", "HV78234"}]
      assert length(attrs) == 4
      {attr1_name, attr1_val, _} = Enum.at(attrs, 0)
      assert attr1_name == "number_of_guests" and attr1_val == 4
      {attr2_name, attr2_val, _} = Enum.at(attrs, 1)
      assert attr2_name == "number_of_rooms" and attr2_val == 2
      {attr3_name, attr3_val, _} = Enum.at(attrs, 2)
      assert attr3_name == "start_date" and attr3_val == "2018-05-09"
      {attr4_name, attr4_val, _} = Enum.at(attrs, 3)
      assert attr4_name == "submit_ip" and attr4_val == "116.207.227.117"
    end
  end

  test "negative integer deserialize_row" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 0, 10,
        10, 2, 3, 4, 3, 0, 0, 0, 105, 110, 116, 5, 9, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255,
        255, 255, 7, 164, 158, 54, 84, 113, 1, 0, 0, 10, 121, 9, 152>>

    {_, [{"int", value, _}]} = PlainBuffer.deserialize_row(row)
    assert value == -1
  end

  test "negative float deserialize_row" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 2, 0, 0, 0, 0, 0, 0, 0, 10,
        63, 2, 3, 4, 6, 0, 0, 0, 102, 108, 111, 97, 116, 49, 5, 9, 0, 0, 0, 1, 174, 71, 225, 122,
        20, 174, 255, 191, 7, 48, 86, 60, 85, 113, 1, 0, 0, 10, 147, 3, 4, 6, 0, 0, 0, 102, 108,
        111, 97, 116, 50, 5, 9, 0, 0, 0, 1, 72, 225, 122, 20, 174, 199, 35, 64, 7, 48, 86, 60, 85,
        113, 1, 0, 0, 10, 2, 3, 4, 6, 0, 0, 0, 102, 108, 111, 97, 116, 51, 5, 9, 0, 0, 0, 1, 143,
        194, 245, 40, 92, 31, 104, 192, 7, 48, 86, 60, 85, 113, 1, 0, 0, 10, 242, 9, 226>>

    {_, [{"float1", f1, _}, {"float2", f2, _}, {"float3", f3, _}]} =
      PlainBuffer.deserialize_row(row)

    assert f1 == -1.98 and f2 == 9.89 and f3 == -192.98
  end

  test "pk with negative integer in deserialize_row" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 4, 0, 0, 0, 110, 97, 109, 101, 5, 12, 0, 0, 0, 3, 7, 0, 0, 0, 116,
        101, 97, 109, 108, 97, 98, 10, 18, 3, 4, 4, 0, 0, 0, 100, 97, 121, 115, 5, 9, 0, 0, 0, 0,
        147, 66, 11, 0, 0, 0, 0, 0, 10, 164, 3, 4, 10, 0, 0, 0, 115, 116, 97, 114, 116, 95, 116,
        105, 109, 101, 5, 9, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 10, 234, 2, 3, 4,
        5, 0, 0, 0, 99, 111, 117, 110, 116, 5, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7, 104, 106,
        168, 22, 114, 1, 0, 0, 10, 156, 3, 4, 8, 0, 0, 0, 101, 110, 100, 95, 116, 105, 109, 101,
        5, 9, 0, 0, 0, 0, 255, 255, 255, 255, 255, 255, 255, 255, 7, 104, 106, 168, 22, 114, 1, 0,
        0, 10, 104, 3, 4, 11, 0, 0, 0, 105, 110, 115, 101, 114, 116, 101, 100, 95, 97, 116, 5, 9,
        0, 0, 0, 0, 206, 30, 190, 94, 0, 0, 0, 0, 7, 104, 106, 168, 22, 114, 1, 0, 0, 10, 250, 3,
        4, 6, 0, 0, 0, 115, 116, 97, 116, 117, 115, 5, 11, 0, 0, 0, 3, 6, 0, 0, 0, 111, 112, 101,
        110, 101, 100, 7, 104, 106, 168, 22, 114, 1, 0, 0, 10, 234, 3, 4, 11, 0, 0, 0, 116, 111,
        116, 97, 108, 95, 99, 111, 117, 110, 116, 5, 9, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 7,
        104, 106, 168, 22, 114, 1, 0, 0, 10, 223, 3, 4, 10, 0, 0, 0, 117, 112, 100, 97, 116, 101,
        100, 95, 97, 116, 5, 9, 0, 0, 0, 0, 206, 30, 190, 94, 0, 0, 0, 0, 7, 104, 106, 168, 22,
        114, 1, 0, 0, 10, 57, 9, 239>>

    {pks, attrs} = PlainBuffer.deserialize_row(row)

    [{"name", _}, {"days", days}, {"start_time", start_time}] = pks

    assert days == 737_939 and start_time == -1

    [
      {"count", count, _},
      {"end_time", end_time, _},
      {"inserted_at", _, _},
      {"status", _, _},
      {"total_count", total_count, _},
      {"updated_at", _, _}
    ] = attrs

    assert count == 0 and end_time == -1 and total_count == 0
  end

  test "tunnel read records put_row" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 10, 0, 0, 0, 0,
        0, 0, 0, 10, 167, 2, 3, 4, 5, 0, 0, 0, 97, 116, 116, 114, 49, 5, 13, 0, 0, 0,
        3, 8, 0, 0, 0, 97, 116, 116, 114, 49, 95, 49, 48, 7, 163, 66, 111, 44, 118, 1,
        0, 0, 10, 31, 3, 4, 5, 0, 0, 0, 100, 97, 116, 97, 49, 5, 13, 0, 0, 0, 3, 8, 0,
        0, 0, 100, 97, 116, 97, 49, 95, 49, 48, 7, 163, 66, 111, 44, 118, 1, 0, 0, 10,
        21, 3, 4, 5, 0, 0, 0, 105, 110, 100, 101, 120, 5, 9, 0, 0, 0, 0, 10, 0, 0, 0,
        0, 0, 0, 0, 7, 163, 66, 111, 44, 118, 1, 0, 0, 10, 167, 11, 24, 0, 0, 0, 12,
        19, 0, 0, 0, 13, 0, 0, 0, 0, 14, 137, 74, 156, 146, 157, 181, 5, 0, 15, 1, 0,
        0, 0, 9, 126>>

    data = ExAliyunOts.PlainBuffer.deserialize_row(row)

    assert data == {[{"id", 10}],
      [
        {"attr1", "attr1_10", 1607063257763},
        {"data1", "data1_10", 1607063257763},
        {"index", 10, 1607063257763}
      ]
    }
  end

  test "tunnel read records delete_row" do
    row =
      <<117, 0, 0, 0, 1, 3, 4, 2, 0, 0, 0, 105, 100, 5, 9, 0, 0, 0, 0, 5, 0, 0, 0, 0,
        0, 0, 0, 10, 70, 8, 11, 24, 0, 0, 0, 12, 19, 0, 0, 0, 13, 0, 0, 0, 0, 14, 166,
        121, 63, 49, 158, 181, 5, 0, 15, 1, 0, 0, 0, 9, 34>>

    data = ExAliyunOts.PlainBuffer.deserialize_row(row)

    assert data == {[{"id", 5}], nil}
  end
end
