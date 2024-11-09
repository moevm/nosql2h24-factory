package db

import "fmt"

type NotFoundError struct{}

func (e *NotFoundError) Error() string {
	return fmt.Sprintf("entity not found in db")
}
