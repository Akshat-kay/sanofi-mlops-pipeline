from metaflow import FlowSpec, step, Parameter

class DrugDiscoveryFlow(FlowSpec):
    data_path = Parameter('data_path', default='s3://sanofi-ml-data-raw/')

    @step
    def start(self):
        import pandas as pd
        self.df = pd.read_csv(self.data_path)  # From S3/Snowflake
        self.next(self.train)

    @step
    def train(self):
        from sklearn.ensemble import RandomForestRegressor
        model = RandomForestRegressor()
        model.fit(self.df.drop('target', axis=1), self.df['target'])
        self.model = model
        self.next(self.end)

    @step
    def end(self):
        print("Training complete!")

if __name__ == '__main__':
    DrugDiscoveryFlow()