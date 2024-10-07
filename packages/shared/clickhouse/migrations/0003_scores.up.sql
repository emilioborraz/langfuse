CREATE TABLE scores (
    `id` String,
    `timestamp` DateTime64(3),
    `project_id` String,
    `trace_id` String,
    `observation_id` Nullable(String),
    `name` String,
    `value` Float64,
    `source` String,
    `comment` Nullable(String) CODEC(ZSTD(1)),
    `author_user_id` Nullable(String),
    `config_id` Nullable(String),
    `data_type` String,
    `string_value` Nullable(String),
    `created_at` DateTime64(3) DEFAULT now(),
    `updated_at` DateTime64(3) DEFAULT now(),
    event_ts DateTime64(3),
    --  PROJECTION average_scores_by_traces_and_name ( 
    --       SELECT
    --         project_id,
    --         trace_id,
    --         observation_id,
    --         name,
    --         avg(value) avg_value
    --       GROUP BY
    --         project_id,
    --         trace_id,
    --         observation_id,
    --         name
    --   ),
    INDEX idx_id id TYPE bloom_filter(0.001) GRANULARITY 1,
    INDEX idx_project_trace_observation (project_id, trace_id, observation_id) TYPE bloom_filter(0.001) GRANULARITY 1
) ENGINE = ReplacingMergeTree Partition by toYYYYMM(timestamp)
ORDER BY (
        project_id,
        toDate(timestamp),
        name,
        id
    )
SETTINGS deduplicate_merge_projection_mode='rebuild';
