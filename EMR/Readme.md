flowchart TD
    A[Start Workflow Trigger<br/>(GitHub Actions / Manual)] --> B[Deploy Lambda Function<br/>+ IAM Role + SG + ESM]
    B --> C[Deploy IBM MQ on EKS]
    C --> D[Deploy CFK Connector<br/>(IBM MQ → Raw Kafka Topic)]
    D --> E[Insert Messages into IBM MQ Queue]
    E --> F[CFK Connector pulls MQ<br/>→ pushes to Raw Kafka Topic]
    F --> G[Event Source Mapping (ESM)<br/>Triggers Lambda on new Kafka Messages]
    G --> H[Lambda processes Raw Msg<br/>→ writes to Processed Kafka Topic]
    H --> I[(Optional) Verify Processed Kafka Messages]
    I --> J[Destroy Lambda Function<br/>+ ESM + (Optional: CFK, MQ)]
    J --> K[End of Workflow]
