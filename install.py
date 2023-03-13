#!/usr/bin/env python

import io
import subprocess
from dataclasses import dataclass
from pathlib import Path
from typing import Iterable, Protocol, Optional, List

from rich import print
from rich.console import Console
from rich.progress import (
    BarColumn,
    Progress,
    SpinnerColumn,
    TaskProgressColumn,
    TextColumn,
)


def xdg_home_config() -> Path:
    return Path.home() / ".config"


def xdg_home_config_subdir(name: str) -> Path:
    return xdg_home_config() / name


def local_config_subdir(name: str) -> Path:
    return Path.cwd() / name


def maybe_symlink_xdb_home_config_subdir_to_local(name: str) -> bool:
    dest_config = xdg_home_config_subdir(name)

    if dest_config.exists():
        return False

    source_config = local_config_subdir(name)
    dest_config.symlink_to(source_config)

    return True


def run_subprocess_command(args: Iterable[str]) -> None:
    proc = subprocess.Popen(args, stdout=subprocess.PIPE, stderr=subprocess.STDOUT)

    for _ in io.TextIOWrapper(proc.stdout, encoding="utf-8"):
        pass

    proc.wait()

    if proc.returncode != 0:
        raise RuntimeError(f"Received exit code {proc.returncode} when running {args}")


@dataclass
class Brew:
    def install(self, name: str) -> None:
        run_subprocess_command(["brew", "install", name])

    def tap(self, name: str) -> None:
        run_subprocess_command(["brew", "tap", name])


class Iterm2:
    def install(self, brew: Brew) -> None:
        brew.install("iterm2")

        brew.tap("homebrew/cask-fonts")
        brew.install("font-fira-mono-nerd-font")

    def description(self) -> str:
        return "iterm2: a third party macos terminal"

    def post_install_instructions(self) -> Optional[str]:
        return None


class Neovim:
    def install(self, brew: Brew) -> None:
        brew.install("neovim")
        _ = maybe_symlink_xdb_home_config_subdir_to_local("nvim")

    def description(self) -> str:
        return "neovim: a modern vim fork"

    def post_install_instructions(self) -> Optional[str]:
        return None


class Zsh:
    def install(self, brew: Brew) -> None:
        _ = maybe_symlink_xdb_home_config_subdir_to_local("zsh")

    def description(self) -> str:
        return "zsh: a configurable shell"

    def post_install_instructions(self) -> Optional[str]:
        return (
            "Add the following to $HOME/.zshenv\n"
            '\techo "#!/bin/env zsh" >> $HOME/.zshenv\n'
            '\t"export ZDOTDIR=$HOME/.config/zsh" >> $HOME/.zshenv\n'
        )


class Tmux:
    def install(self, brew: Brew) -> None:
        _ = maybe_symlink_xdb_home_config_subdir_to_local("tmux")

    def description(self) -> str:
        return "tmux: a terminal multiplexer"

    def post_install_instructions(self) -> Optional[str]:
        return None


class GitLFS:
    def install(self, brew: Brew) -> None:
        brew.install("git-lfs")
        run_subprocess_command(["git-lfs", "install"])

    def description(self) -> str:
        return "git-lfs: git for large files"

    def post_install_instructions(self) -> Optional[str]:
        return None


class Helix:
    def install(self, brew: Brew) -> None:
        brew.install("helix")
        _ = maybe_symlink_xdb_home_config_subdir_to_local("helix")

    def description(self) -> str:
        return "helix: a post-modern editor"

    def post_install_instructions(self) -> Optional[str]:
        return None


class PackageProtocol(Protocol):
    def install(self, brew: Brew) -> None:
        pass

    def description(self) -> str:
        pass

    def post_install_instructions(self) -> Optional[str]:
        pass


def install_component(component: PackageProtocol, brew: Brew) -> None:
    component.install(brew)


def main() -> None:
    brew = Brew()

    console = Console(record=True)

    columns = [
        SpinnerColumn(),
        TextColumn("[progress.description]{task.description}"),
        BarColumn(),
        TaskProgressColumn(),
    ]

    components: List[PackageProtocol] = [
        Iterm2(),
        Neovim(),
        Zsh(),
        Tmux(),
        GitLFS(),
        Helix(),
    ]

    post_install_instructions: List[str] = []

    with Progress(*columns, console=console, transient=False) as progress:
        for component in components:
            task = progress.add_task(
                f"Installing {component.description()}", total=None
            )

            install_component(component, brew)

            progress.update(
                task,
                description=f"Installed {component.description()}",
                total=100,
                completed=100,
            )

            if (instruction := component.post_install_instructions()) is not None:
                post_install_instructions.append(instruction)

    for instruction in post_install_instructions:
        print()
        print(instruction)
        print()


if __name__ == "__main__":
    main()
