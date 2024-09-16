"""
Plot the value of the metric for worker scaling

Example

  python -m development.script.generate_module elb/load_balancer resource.aws_lb.this_lb elb
"""

import argparse
import typing

import matplotlib.figure as mp_fig
import matplotlib.pyplot as mp_plot
import numpy as np
from matplotlib import colormaps as mp_cm

MAX_BACKLOG = 6
MAX_WORKERS = 6
TARGET_BACKLOG = 0


def parse_args(
    args_in: typing.Optional[list[str]] = None,
) -> argparse.Namespace:
    args = argparse.ArgumentParser()
    parsed_args = args.parse_args(args_in)
    return parsed_args


def metric(
    max_workers: int, target_backlog: int, num_workers: int, backlog: int
) -> float:
    """
    All backlogs are greater than no backlog
    Monotonic in both backlog and workers
    1:0 is 80 so 4*B*M/0.5
    1:1 is 40 so 4*B*M/N
    1:10 is 4 so 4*B*M/N
    0:0 is 2 so (B+1)/0.5
    0:1 is 1 so (B+1)/N
    0:10 is 0.1 so (B+1)/N
    """
    numerator = 4 * backlog * max_workers if backlog > target_backlog else backlog + 1
    denominator = max(num_workers, 0.5)
    return numerator / denominator


@np.vectorize
def metric_wrapper(num_workers: int, backlog: int) -> float:
    return metric(MAX_WORKERS, TARGET_BACKLOG, num_workers, backlog)


def plot_metric() -> None:
    for i_worker in range(1, 11):
        print(
            f"Metric for 0:{i_worker} is {metric(MAX_WORKERS, TARGET_BACKLOG, i_worker, 0)}"
        )

    workers = np.arange(0, MAX_WORKERS + 1, 1)
    backlog = np.arange(0, MAX_BACKLOG + 1, 1)
    x, y = np.meshgrid(workers, backlog)
    z = metric_wrapper(x, y)

    fig = mp_plot.figure(figsize=mp_fig.figaspect(0.5))

    ax = fig.add_subplot(1, 2, 1, projection="3d")
    ax.plot_surface(  # type: ignore
        x,
        y,
        z,
        cmap=mp_cm.coolwarm,  # type: ignore
        linewidth=0,
        antialiased=False,
    )
    ax.set_xlim(0, MAX_WORKERS)
    ax.set_ylim(0, MAX_BACKLOG)

    ax = fig.add_subplot(1, 2, 2, projection="3d")
    ax.plot_wireframe(  # type: ignore
        x,
        y,
        z,
    )
    ax.set_xlim(0, MAX_WORKERS)
    ax.set_ylim(0, MAX_BACKLOG)

    mp_plot.show()


def main(
    args_in: typing.Optional[list[str]] = None,
) -> None:
    args = parse_args(args_in)
    plot_metric(**vars(args))


if __name__ == "__main__":
    main()
