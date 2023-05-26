//
//  ViewController.swift
//  barley-break
//
//  Created by Андрей Лосюков on 26.05.2023.
//

import UIKit


class BarleyBreakViewController: UIViewController {

    private let spacing = 20.0

    private var count = 0

    // IndexPath пустой ячейки
    private var whiteSpaceIndexPath: IndexPath?

    // Все числа в игре, 16 - пустая ячейка
    private var digits = [
        1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
    ]

    // Лейбл с информациией об игре
    private lazy var gameInfo: UILabel = {
        let label = UILabel()
        label.text = "Сделано ходов: \(count)"
        label.font = .boldSystemFont(ofSize: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = spacing
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.register(BarleyBreakCell.self,
            forCellWithReuseIdentifier: "BarleyBreakCell")
        return collectionView
    }()

    // Кнопка с началом новой игры
    private lazy var startButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .black
        button.tintColor = .white
        button.setTitle("Начать игру заново", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 15.0
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(startNewGame), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    func setupUI() {
        // Перемешиваем массив
        digits.shuffle()
        view.backgroundColor = .white
        view.addSubview(gameInfo)
        view.addSubview(collectionView)
        view.addSubview(startButton)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .black
        setupGameInfo()
        setupStartButtonConstraints()
        setupCollectionViewConstraints()
    }

    func setupGameInfo() {
        NSLayoutConstraint.activate([
            gameInfo.topAnchor.constraint(equalTo: collectionView.bottomAnchor, constant: 35),
            gameInfo.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }

    func setupCollectionViewConstraints() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.heightAnchor.constraint(equalToConstant: UIScreen.main.bounds.width)
        ])
    }

    func setupStartButtonConstraints() {
        NSLayoutConstraint.activate([
            startButton.heightAnchor.constraint(equalToConstant: 50.0),
            startButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 30.0),
            startButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -30.0),
            startButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            startButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -35.0)
        ])
    }

    // Проверяем что ячейка, на которую нажали, соседничает границами с пустой ячейкой (т. е. можем поменять)
    func checkChangePossible(pos: Int) -> Bool {
        guard let whiteSpaceIndexPath = whiteSpaceIndexPath else {
            return false
        }
        if pos == whiteSpaceIndexPath.item - 1 ||  pos == whiteSpaceIndexPath.item + 1 ||
            pos == whiteSpaceIndexPath.item + 4 || pos == whiteSpaceIndexPath.item - 4 {
            return true
        }
        else {
            return false
        }
    }

    // Проверка на победу (все числа по возрастанию)
    func checkIsItWin() -> Bool {
        for i in 1..<digits.count {
          if digits[i-1] > digits[i] { return false }
        }
        return true
    }

    // Алерт с победой
    func showWinAlert() {
        let winAlert = UIAlertController(title: "Победа!",
                                             message: "Поздравляем!", preferredStyle: .alert)
        winAlert.addAction(UIAlertAction(title: "ОК", style: .cancel, handler: {_ in
        }))
        present(winAlert, animated: true)
    }

    // Начало новой игры
    @objc func startNewGame() {
        digits.shuffle()
        collectionView.reloadData()
        count = 0
        gameInfo.text = "Сделано ходов: \(count)"
        collectionView.isUserInteractionEnabled = true
    }
}


extension BarleyBreakViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 16
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath)
    -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "BarleyBreakCell",
            for: indexPath) as? BarleyBreakCell else {
                return UICollectionViewCell()
            }
        // Конфигурируемся ячейку числом, если число не 16 (тогда ячейка - пустая)
        if digits[indexPath.item] != 16 {
            cell.configure(with: digits[indexPath.item])
        } else {
            // Запоминаем IndexPath пустой ячейки
            whiteSpaceIndexPath = indexPath
            cell.configure(with: nil)
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        guard collectionView.dequeueReusableCell(
            withReuseIdentifier: "BarleyBreakCell",
            for: indexPath) is BarleyBreakCell else {
            return
        }
        if checkChangePossible(pos: indexPath.item) {
            if let whiteSpaceIndexPath = whiteSpaceIndexPath {
                self.collectionView.performBatchUpdates({
                    // Меняем местами ячейки
                    self.collectionView.moveItem(at: whiteSpaceIndexPath, to: indexPath)
                    self.collectionView.moveItem(at: indexPath, to: whiteSpaceIndexPath)
                }, completion: { [weak self] _ in
                    let c = self?.digits[indexPath.item]
                    self?.digits[indexPath.item] = self?.digits[self?.whiteSpaceIndexPath?.item ?? 0] ?? 0
                    self?.digits[whiteSpaceIndexPath.item] = c ?? 0
                    self?.whiteSpaceIndexPath = indexPath
                    // Увеличиваем количество ходов
                    self?.count += 1
                    // Проверяем на победу
                    if self?.checkIsItWin() ?? false {
                        // Показываем алерт и лейбл с победой
                        self?.showWinAlert()
                        self?.gameInfo.text = "Игра закончена за \(self?.count ?? 0) ходов"
                        self?.collectionView.isUserInteractionEnabled = false
                    } else {
                        // Показываем количество сделанных ходов
                        self?.gameInfo.text = "Сделано ходов: \(self?.count ?? 0)"
                    }
                })
            }
        }
    }
}

extension BarleyBreakViewController: UICollectionViewDelegateFlowLayout {

    //  Размер ячейки
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {

        let availableWidth = collectionView.bounds.width - spacing * 5
        let itemWidth = (availableWidth / 4).rounded(.down)
        return CGSize(width: itemWidth, height: itemWidth)
    }

    // Отступы между ячейками
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: spacing, left: spacing, bottom: spacing, right: spacing)
    }
}
