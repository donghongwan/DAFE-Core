# data/data_visualization.py

import matplotlib.pyplot as plt
import seaborn as sns
import plotly.express as px
import logging
import os

# Configure logging
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

class DataVisualizer:
    def __init__(self):
        sns.set(style="whitegrid")  # Set the default style for seaborn

    def plot_user_balance(self, data, save_path=None):
        """Plot user balances as a bar chart."""
        logger.info("Creating user balance bar plot.")
        plt.figure(figsize=(12, 6))
        sns.barplot(x='address', y='balance', data=data, palette='viridis')
        plt.title('User  Balances')
        plt.xlabel('User  Address')
        plt.ylabel('Balance')
        plt.xticks(rotation=45)
        plt.tight_layout()

        if save_path:
            plt.savefig(save_path)
            logger.info(f"User  balance plot saved to {save_path}.")
        plt.show()

    def plot_aggregated_data(self, data, group_by_column, save_path=None):
        """Plot aggregated data as a line chart."""
        logger.info(f"Creating aggregated data line plot for {group_by_column}.")
        plt.figure(figsize=(12, 6))
        sns.lineplot(x=group_by_column, y='balance', data=data, marker='o')
        plt.title(f'Aggregated Balances by {group_by_column}')
        plt.xlabel(group_by_column)
        plt.ylabel('Total Balance')
        plt.xticks(rotation=45)
        plt.tight_layout()

        if save_path:
            plt.savefig(save_path)
            logger.info(f"Aggregated data plot saved to {save_path}.")
        plt.show()

    def plot_interactive_user_balance(self, data):
        """Create an interactive plot of user balances using Plotly."""
        logger.info("Creating interactive user balance plot.")
        fig = px.bar(data, x='address', y='balance', title='User  Balances', color='balance',
                     labels={'address': 'User  Address', 'balance': 'Balance'},
                     color_continuous_scale=px.colors.sequential.Viridis)
        fig.show()

    def save_visualization(self, fig, file_name, file_format='png'):
        """Save a visualization to a file."""
        if file_format not in ['png', 'jpg', 'pdf', 'svg']:
            logger.error(f"Unsupported file format: {file_format}. Supported formats: png, jpg, pdf, svg.")
            return

        try:
            fig.write_image(f"{file_name}.{file_format}")
            logger.info(f"Visualization saved as {file_name}.{file_format}.")
        except Exception as e:
            logger.error(f"Error saving visualization: {e}")

    def generate_report(self, data, report_path):
        """Generate a report with visualizations and save it to a file."""
        logger.info(f"Generating report at {report_path}.")
        with open(report_path, 'w') as f:
            f.write("# Data Visualization Report\n\n")
            f.write("## User Balances\n")
            self.plot_user_balance(data, save_path='user_balances.png')
            f.write("![User  Balances](user_balances.png)\n\n")

            f.write("## Aggregated Balances\n")
            aggregated_data = data.groupby('address').sum().reset_index()
            self.plot_aggregated_data(aggregated_data, 'address', save_path='aggregated_balances.png')
            f.write("![Aggregated Balances](aggregated_balances.png)\n\n")

        logger.info("Report generation completed.")
