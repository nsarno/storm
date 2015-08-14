defmodule Storm.Metrics.CompletionBucketTest do
  use ExUnit.Case
  alias Storm.Metrics.CompletionBucket, as: Bucket

  test "is already started" do
    assert {:error, {:already_started, _}} = Bucket.start_link
  end

  test "put a new value" do
    assert :ok = Bucket.put(:one, "value")
  end

  test "pop value for key" do
    assert :ok = Bucket.put(:one, "value")
    assert "value" = Bucket.pop(:one)
    assert nil = Bucket.pop(:one)
  end
end
