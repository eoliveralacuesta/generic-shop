package products

type Service struct {
	repo Repository
}

func NewService(r Repository) *Service {
	return &Service{repo: r}
}

func (s *Service) List() ([]Product, error) {
	return s.repo.List()
}
